import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://zofoksogwwiuiojrbqkp.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvZm9rc29nd3dpdWlvanJicWtwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0NDQ1MjgsImV4cCI6MjA4MTAyMDUyOH0.GILObKG6Wp0J4siPy9ctCMuArg3zL1zIS3mCBxwXJPk';
  static const String tableName = 'submissions';

  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Supabase initialization failed: $e');
      rethrow;
    }
  }

  SupabaseClient get client => Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllItems() async {
    try {
      final response = await client.from(tableName).select().order('created_at', ascending: false);
      print('✅ Fetched ${response.length} submissions');
      return response;
    } catch (e) {
      print('❌ Error fetching submissions: $e');
      throw Exception('Failed to fetch submissions: $e');
    }
  }

  Future<Map<String, dynamic>> getItemById(String id) async {
    try {
      final response = await client
          .from(tableName)
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch submission: $e');
    }
  }

  Future<Map<String, dynamic>> createItem(Map<String, dynamic> data) async {
    try {
      print('📝 Creating submission with data: $data');
      final response = await client.from(tableName).insert([data]).select();
      print('✅ Submission created successfully: ${response[0]}');
      return response[0];
    } catch (e) {
      print('❌ Error creating submission: $e');
      throw Exception('Failed to create submission: $e');
    }
  }

  Future<Map<String, dynamic>> updateItem(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      print('✏️ Updating submission $id with data: $data');
      final response = await client
          .from(tableName)
          .update(data)
          .eq('id', id)
          .select();
      print('✅ Submission updated successfully');
      return response[0];
    } catch (e) {
      print('❌ Error updating submission: $e');
      throw Exception('Failed to update submission: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      print('🗑️ Deleting submission $id');
      await client.from(tableName).delete().eq('id', id);
      print('✅ Submission deleted successfully');
    } catch (e) {
      print('❌ Error deleting submission: $e');
      throw Exception('Failed to delete submission: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    try {
      final response = await client
          .from(tableName)
          .select()
          .or('full_name.ilike.%$query%,email.ilike.%$query%,phone.ilike.%$query%');
      return response;
    } catch (e) {
      throw Exception('Failed to search submissions: $e');
    }
  }
}
