import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Login
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Register
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  // Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return _supabase.auth.currentUser?.email;
  }

  // Get full user object
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception("User belum login");
    }

    final response =
        await _supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle(); // kalau null, ga error

    return response;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception("User belum login");
    }

    final response =
        await _supabase.from('users').select().eq('id', user.id).maybeSingle();

    return response;
  }
}
