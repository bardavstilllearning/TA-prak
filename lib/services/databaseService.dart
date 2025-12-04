import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';

class DatabaseService {
  static const String _userBoxName = 'users';
  static const String _sessionBoxName = 'session';

  // Initialize Hive
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }

    // Open boxes
    await Hive.openBox<User>(_userBoxName);
    await Hive.openBox(_sessionBoxName);

    print('✅ Hive database initialized successfully');
  }

  // Get user box
  static Box<User> getUserBox() {
    return Hive.box<User>(_userBoxName);
  }

  // Get session box
  static Box getSessionBox() {
    return Hive.box(_sessionBoxName);
  }

  // Hash password
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ============== USER CRUD OPERATIONS ==============

  // Register new user
  static Future<Map<String, dynamic>> register({
    required String username,
    required String namaLengkap,
    required String password,
  }) async {
    try {
      final userBox = getUserBox();

      // Check if username already exists
      final existingUser = userBox.values.firstWhere(
        (user) => user.username.toLowerCase() == username.toLowerCase(),
        orElse: () => User(
          id: '',
          username: '',
          namaLengkap: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      if (existingUser.id.isNotEmpty) {
        return {'success': false, 'message': 'Username sudah terdaftar'};
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        namaLengkap: namaLengkap,
        password: hashPassword(password),
        createdAt: DateTime.now(),
      );

      // Save to database
      await userBox.add(newUser);

      print('✅ User registered: ${newUser.username}');

      return {
        'success': true,
        'message': 'Registrasi berhasil',
        'user': newUser.toMap(),
      };
    } catch (e) {
      print('❌ Registration error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final userBox = getUserBox();
      final hashedPassword = hashPassword(password);

      // Find user
      final user = userBox.values.firstWhere(
        (user) =>
            user.username.toLowerCase() == username.toLowerCase() &&
            user.password == hashedPassword,
        orElse: () => User(
          id: '',
          username: '',
          namaLengkap: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      if (user.id.isEmpty) {
        return {'success': false, 'message': 'Username atau password salah'};
      }

      // Save session
      await saveSession(user);

      print('✅ User logged in: ${user.username}');

      return {
        'success': true,
        'message': 'Login berhasil',
        'user': user.toMap(),
      };
    } catch (e) {
      print('❌ Login error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Get user by ID
  static Future<User?> getUserById(String userId) async {
    try {
      final userBox = getUserBox();

      final user = userBox.values.firstWhere(
        (user) => user.id == userId,
        orElse: () => User(
          id: '',
          username: '',
          namaLengkap: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      return user.id.isNotEmpty ? user : null;
    } catch (e) {
      print('❌ Get user error: $e');
      return null;
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUser({
    required String userId,
    String? namaLengkap,
    String? username,
    String? password,
    String? urlFoto,
  }) async {
    try {
      final userBox = getUserBox();

      // Find user index
      final userIndex = userBox.values.toList().indexWhere(
        (user) => user.id == userId,
      );

      if (userIndex == -1) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      final user = userBox.getAt(userIndex)!;

      // Check if new username already exists (if username is being changed)
      if (username != null && username != user.username) {
        final existingUser = userBox.values.firstWhere(
          (u) =>
              u.username.toLowerCase() == username.toLowerCase() &&
              u.id != userId,
          orElse: () => User(
            id: '',
            username: '',
            namaLengkap: '',
            password: '',
            createdAt: DateTime.now(),
          ),
        );

        if (existingUser.id.isNotEmpty) {
          return {'success': false, 'message': 'Username sudah digunakan'};
        }
      }

      // Update fields
      if (namaLengkap != null) user.namaLengkap = namaLengkap;
      if (username != null) user.username = username;
      if (password != null) user.password = hashPassword(password);
      if (urlFoto != null) user.urlFoto = urlFoto;
      user.updatedAt = DateTime.now();

      // Save changes
      await user.save();

      // Update session if this is the current user
      final sessionBox = getSessionBox();
      final currentUserId = sessionBox.get('user_id');
      if (currentUserId == userId) {
        await saveSession(user);
      }

      print('✅ User updated: ${user.username}');

      return {
        'success': true,
        'message': 'Profile berhasil diupdate',
        'user': user.toMap(),
      };
    } catch (e) {
      print('❌ Update user error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Delete user
  static Future<bool> deleteUser(String userId) async {
    try {
      final userBox = getUserBox();

      final userIndex = userBox.values.toList().indexWhere(
        (user) => user.id == userId,
      );

      if (userIndex != -1) {
        await userBox.deleteAt(userIndex);
        print('✅ User deleted: $userId');
        return true;
      }

      return false;
    } catch (e) {
      print('❌ Delete user error: $e');
      return false;
    }
  }

  // ============== SESSION MANAGEMENT ==============

  // Save login session
  static Future<void> saveSession(User user) async {
    final sessionBox = getSessionBox();
    await sessionBox.put('user_id', user.id);
    await sessionBox.put('username', user.username);
    await sessionBox.put('login_time', DateTime.now().toIso8601String());
    print('✅ Session saved for: ${user.username}');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final sessionBox = getSessionBox();
      final userId = sessionBox.get('user_id');
      final loginTime = sessionBox.get('login_time');

      if (userId == null || loginTime == null) {
        return false;
      }

      // Check if session is still valid (7 days)
      final loginDateTime = DateTime.parse(loginTime);
      final difference = DateTime.now().difference(loginDateTime).inDays;

      if (difference >= 7) {
        await clearSession();
        return false;
      }

      return true;
    } catch (e) {
      print('❌ Check login error: $e');
      return false;
    }
  }

  // Get current user from session
  static Future<User?> getCurrentUser() async {
    try {
      final sessionBox = getSessionBox();
      final userId = sessionBox.get('user_id');

      if (userId == null) return null;

      return await getUserById(userId);
    } catch (e) {
      print('❌ Get current user error: $e');
      return null;
    }
  }

  // Get current username
  static Future<String?> getCurrentUsername() async {
    try {
      final sessionBox = getSessionBox();
      return sessionBox.get('username');
    } catch (e) {
      print('❌ Get username error: $e');
      return null;
    }
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    try {
      final sessionBox = getSessionBox();
      await sessionBox.clear();
      print('✅ Session cleared');
    } catch (e) {
      print('❌ Clear session error: $e');
    }
  }

  // Check if session is valid
  static Future<bool> isSessionValid() async {
    return await isLoggedIn();
  }

  // ============== UTILITY METHODS ==============

  // Get all users (for debugging)
  static List<User> getAllUsers() {
    final userBox = getUserBox();
    return userBox.values.toList();
  }

  // Close all boxes
  static Future<void> close() async {
    await Hive.close();
    print('✅ Hive closed');
  }

  // Clear all data (for testing)
  static Future<void> clearAllData() async {
    final userBox = getUserBox();
    final sessionBox = getSessionBox();

    await userBox.clear();
    await sessionBox.clear();

    print('✅ All data cleared');
  }
}
