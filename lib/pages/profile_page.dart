import 'package:flutter/material.dart';
import 'package:latres_mobile/pages/login_page.dart';
import 'package:latres_mobile/services/session_service.dart';
import 'package:latres_mobile/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    SessionService.getUsername().then((v) {
      if (mounted) setState(() => _username = v);
    });
  }

  Future<void> _logout() async {
    await SessionService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 44,
                backgroundColor: AppConst.card,
                child: Icon(Icons.person, size: 48, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Text(_username,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Kesan: Praktikum Mobile seru banget dan bikin ketagihan ngoding, materinya jelas dan praktiknya langsung kepake.\nPesan: Makasih banyak kakak asisten, semoga praktikum Mobile makin mantap dan sukses terus!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConst.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: _logout,
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
