import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../Landing/widgets/custom_snackbar.dart';
import '../services/databaseService.dart';

class ProfileController {
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = await DatabaseService.getCurrentUser();
      return user?.toMap();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Update profile
  Future<bool> updateProfile(
    BuildContext context,
    GlobalKey<FormState> formKey,
    ValueNotifier<bool> isLoading,
  ) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isLoading.value = true;

    try {
      final currentUser = await DatabaseService.getCurrentUser();

      if (currentUser == null) {
        throw Exception('User tidak ditemukan');
      }

      final response = await DatabaseService.updateUser(
        userId: currentUser.id,
        namaLengkap: namaLengkapController.text.isNotEmpty
            ? namaLengkapController.text
            : null,
        username: usernameController.text.isNotEmpty
            ? usernameController.text
            : null,
        password: passwordController.text.isNotEmpty
            ? passwordController.text
            : null,
      );

      print('Update Profile Response: $response');

      if (response['success'] == true) {
        if (context.mounted) {
          CustomSnackbar.show(
            context,
            message: "Profil berhasil diperbarui!",
            backgroundColor: Colors.red,
          );
        }
        return true;
      } else {
        if (context.mounted) {
          CustomSnackbar.show(
            context,
            message: response['message'] ?? "Update gagal",
            backgroundColor: Colors.red,
          );
        }
        return false;
      }
    } catch (e) {
      print('Update Profile Error: $e');

      if (context.mounted) {
        CustomSnackbar.show(
          context,
          message: "Error: $e",
          backgroundColor: Colors.red,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Upload photo
  Future<bool> uploadPhoto(
    BuildContext context,
    ValueNotifier<bool> isLoading,
  ) async {
    final picker = ImagePicker();

    try {
      // Pilih foto dari galeri
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        if (context.mounted) {
          CustomSnackbar.show(
            context,
            message: "Tidak ada foto yang dipilih",
            backgroundColor: Colors.orange,
          );
        }
        return false;
      }

      isLoading.value = true;

      final currentUser = await DatabaseService.getCurrentUser();

      if (currentUser == null) {
        throw Exception('User tidak ditemukan');
      }

      // Save image to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'profile_${currentUser.id}_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');

      // Update user with photo path
      final response = await DatabaseService.updateUser(
        userId: currentUser.id,
        urlFoto: savedImage.path,
      );

      print('Upload Photo Response: $response');

      if (response['success'] == true) {
        if (context.mounted) {
          CustomSnackbar.show(
            context,
            message: response['message'] ?? "Foto berhasil diupload",
            backgroundColor: Colors.green,
          );
        }
        return true;
      } else {
        if (context.mounted) {
          CustomSnackbar.show(
            context,
            message: response['message'] ?? "Upload gagal",
            backgroundColor: Colors.red,
          );
        }
        return false;
      }
    } catch (e) {
      print('Error uploading photo: $e');

      if (context.mounted) {
        CustomSnackbar.show(
          context,
          message: "Error: $e",
          backgroundColor: Colors.red,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Validation methods
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return null; // Password optional
    if (value.length < 3) return 'Password minimal 3 karakter';
    return null;
  }

  String? validateNamaLengkap(String? value) {
    if (value == null || value.isEmpty) return 'Nama lengkap harus diisi';
    if (value.length < 2) return 'Nama lengkap minimal 2 karakter';
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username harus diisi';
    if (value.length < 3) return 'Username minimal 3 karakter';
    return null;
  }

  void dispose() {
    namaLengkapController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
