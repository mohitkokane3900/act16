import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = AuthService();
  final passCtl = TextEditingController();
  bool loading = false;
  String info = '';

  Future<void> _changePassword() async {
    final p = passCtl.text.trim();
    if (p.length < 6) {
      setState(() => info = 'Password must be 6+ characters');
      return;
    }
    setState(() {
      loading = true;
      info = '';
    });
    try {
      await auth.changePassword(p);
      if (mounted) {
        setState(() {
          loading = false;
          passCtl.clear();
          info = 'Password updated';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          info = 'Update failed';
        });
      }
    }
  }

  Future<void> _logout() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final email = auth.currentUser()?.email ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(email, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
                controller: passCtl,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true),
            const SizedBox(height: 12),
            if (info.isNotEmpty)
              Text(info,
                  style: TextStyle(
                      color:
                          info.contains('failed') ? Colors.red : Colors.green)),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: loading ? null : _changePassword,
                child: Text(loading ? 'Please wait' : 'Change Password')),
            const SizedBox(height: 24),
            OutlinedButton(onPressed: _logout, child: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}
