import '../services/databaseService.dart';

class SessionService {
  // Check authentication status
  static Future<bool> checkAuthStatus() async {
    try {
      return await DatabaseService.isLoggedIn();
    } catch (e) {
      print('Auth Check Error: $e');
      return false;
    }
  }

  // Clear expired session
  static Future<void> clearExpiredSession() async {
    try {
      final isValid = await DatabaseService.isSessionValid();
      if (!isValid) {
        await DatabaseService.clearSession();
      }
    } catch (e) {
      print('Clear Session Error: $e');
    }
  }

  // Get username
  static Future<String?> getUsername() async {
    return await DatabaseService.getCurrentUsername();
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final user = await DatabaseService.getCurrentUser();
    return user?.toMap();
  }

  // Logout
  static Future<void> logout() async {
    await DatabaseService.clearSession();
  }
}
