import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Landing/widgets/custom_snackbar.dart';
import '../services/databaseService.dart';

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Handle login dengan Hive
  Future<void> handleLogin(
    BuildContext context,
    GlobalKey<FormState> formKey,
    ValueNotifier<bool> isLoading,
  ) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        final response = await DatabaseService.login(
          username: usernameController.text,
          password: passwordController.text,
        );

        print('Login Response: $response');

        if (response['success'] == true) {
          if (context.mounted) {
            CustomSnackbar.show(
              context,
              message: "Login berhasil!",
              backgroundColor: Colors.green,
            );

            // Clear form
            usernameController.clear();
            passwordController.clear();

            // Navigasi ke halaman utama
            context.go('/home');
          }
        } else {
          if (context.mounted) {
            CustomSnackbar.show(
              context,
              message: response['message'] ?? "Login gagal",
              backgroundColor: Colors.red,
            );
          }
        }
      } catch (e) {
        print('Login Error: $e');

        if (context.mounted) {
          CustomSnackbar.show(
            context,
            message: "Error: $e",
            backgroundColor: Colors.red,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Handle logout
  Future<void> handleLogout(BuildContext context) async {
    try {
      await DatabaseService.clearSession();

      if (context.mounted) {
        CustomSnackbar.show(
          context,
          message: "Logout berhasil!",
          backgroundColor: Colors.green,
        );

        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.show(
          context,
          message: "Terjadi kesalahan saat logout",
          backgroundColor: Colors.red,
        );
      }
    }
  }

  // Get current username
  Future<String?> getUsername() async {
    return await DatabaseService.getCurrentUsername();
  }

  // Get current user data
  Future<Map<String, dynamic>?> getUserData() async {
    final user = await DatabaseService.getCurrentUser();
    return user?.toMap();
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    return await DatabaseService.isLoggedIn();
  }

  // Check if session is valid
  Future<bool> isSessionValid() async {
    return await DatabaseService.isSessionValid();
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
