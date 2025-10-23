import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz 2 - SQLite CRUD',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database? database;
  List<Map<String, dynamic>> userList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  File? imageFile;
  int? selectedId;

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'users.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            age TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
    loadUsers();
  }

  Future<void> loadUsers() async {
    final data = await database!.query('users');
    setState(() {
      userList = data;
    });
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> addUser() async {
    await database!.insert('users', {
      'name': nameController.text,
      'email': emailController.text,
      'age': ageController.text,
      'imagePath': imageFile?.path
    });
    clearFields();
    loadUsers();
  }

  Future<void> updateUser() async {
    await database!.update(
      'users',
      {
        'name': nameController.text,
        'email': emailController.text,
        'age': ageController.text,
        'imagePath': imageFile?.path
      },
      where: 'id = ?',
      whereArgs: [selectedId],
    );
    clearFields();
    loadUsers();
  }

  Future<void> deleteUser(int id) async {
    await database!.delete('users', where: 'id = ?', whereArgs: [id]);
    loadUsers();
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    ageController.clear();
    imageFile = null;
    selectedId = null;
  }

  void fillFields(Map<String, dynamic> user) {
    nameController.text = user['name'];
    emailController.text = user['email'];
    ageController.text = user['age'];
    imageFile = user['imagePath'] != null ? File(user['imagePath']) : null;
    selectedId = user['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite CRUD App')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage:
                    imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? const Icon(Icons.camera_alt, size: 35)
                    : null,
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: addUser,
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: selectedId == null ? null : updateUser,
                  child: const Text('Update'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return Card(
                    child: ListTile(
                      leading: user['imagePath'] != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(File(user['imagePath'])))
                          : const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(user['name'] ?? ''),
                      subtitle: Text('${user['email']} | Age: ${user['age']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.teal),
                            onPressed: () => fillFields(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteUser(user['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
