import 'package:flutter/material.dart';
import '../controller/loginController.dart';

class LoginCard extends StatefulWidget {
  final VoidCallback onSwitch;
  const LoginCard({super.key, required this.onSwitch});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _loginController = LoginController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  bool showPassword = false;

  @override
  void dispose() {
    _loginController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat Datang Kembali!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Masuk untuk melanjutkan",
              style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
            ),

            const SizedBox(height: 28),

            const Text(
              'Username',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _loginController.usernameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: 'Masukkan username Anda',
                hintStyle: const TextStyle(
                  color: Color(0xFFBDC3C7),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF6BB6FF),
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E6ED)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E6ED)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6BB6FF),
                    width: 2,
                  ),
                ),
                fillColor: const Color(0xFFF8F9FA),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _loginController.passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                hintText: 'Masukkan password Anda',
                hintStyle: const TextStyle(
                  color: Color(0xFFBDC3C7),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF6BB6FF),
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF6BB6FF),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E6ED)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E6ED)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6BB6FF),
                    width: 2,
                  ),
                ),
                fillColor: const Color(0xFFF8F9FA),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 3) {
                  return 'Password minimal 3 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),

            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => _loginController.handleLogin(
                            context,
                            _formKey,
                            _isLoading,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6BB6FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: const Color(0xFF6BB6FF).withOpacity(0.3),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'MASUK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: widget.onSwitch,
                child: const Text.rich(
                  TextSpan(
                    text: 'Belum punya akun? ',
                    style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Daftar di sini',
                        style: TextStyle(
                          color: Color(0xFF6BB6FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
