import 'package:flutter/material.dart';
import 'package:latres_mobile/pages/main_page.dart';
import 'package:latres_mobile/services/session_service.dart';
import 'package:latres_mobile/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userC = TextEditingController();
  final _passC = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _userC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final user = _userC.text.trim();
    final pass = _passC.text;

    if (user == AppConst.nim && pass == AppConst.password) {
      setState(() => _loading = true);
      await SessionService.saveLogin(user);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username atau password salah')),
      );
    }
  }

  InputDecoration _deco(String hint, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppConst.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.movie_creation_rounded,
                    size: 72, color: AppConst.primary),
                const SizedBox(height: 12),
                const Text(
                  AppConst.appName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 36),
                TextField(
                  controller: _userC,
                  decoration: _deco('Username', Icons.person),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _passC,
                  obscureText: _obscure,
                  decoration: _deco(
                    'Password',
                    Icons.lock,
                    suffix: IconButton(
                      icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConst.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _loading ? null : _login,
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
