import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/create_screen.dart';
import 'screens/update_screen.dart';
import 'screens/detail_screen.dart';
import 'models/item_model.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submission Form App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF06B6D4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF06B6D4),
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/create': (context) => const CreateScreen(),
        '/update': (context) {
          final item = ModalRoute.of(context)!.settings.arguments as Item;
          return UpdateScreen(item: item);
        },
        '/detail': (context) {
          final item = ModalRoute.of(context)!.settings.arguments as Item;
          return DetailScreen(item: item);
        },
      },
    );
  }
}