import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Landing/widgets/custom_snackbar.dart';
import '../services/databaseService.dart';

class RegisterController {
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> handleRegister(
    BuildContext context,
    GlobalKey<FormState> formKey,
    ValueNotifier<bool> isLoading,
  ) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        final response = await DatabaseService.register(
          username: usernameController.text,
          namaLengkap: namaLengkapController.text,
          password: passwordController.text,
        );

        print('Register Response: $response');

        if (response['success'] == true) {
          if (context.mounted) {
            CustomSnackbar.show(
              context,
              message: "Registrasi berhasil! Silahkan login.",
              backgroundColor: Colors.green,
            );

            context.go('/login');
          }
        } else {
          if (context.mounted) {
            CustomSnackbar.show(
              context,
              message: response['message'] ?? "Registrasi gagal",
              backgroundColor: Colors.red,
            );
          }
        }
      } catch (e) {
        print('Register Error: $e');

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

  void dispose() {
    namaLengkapController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
