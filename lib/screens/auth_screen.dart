import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = AuthService();
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();
  bool isRegister = false;
  bool loading = false;
  String error = '';

  bool _validEmail(String s) {
    return s.contains('@') && s.contains('.');
  }

  Future<void> _submit() async {
    final email = emailCtl.text.trim();
    final pass = passCtl.text.trim();
    if (!_validEmail(email)) {
      setState(() => error = 'Enter a valid email');
      return;
    }
    if (pass.length < 6) {
      setState(() => error = 'Password must be 6+ characters');
      return;
    }
    setState(() {
      error = '';
      loading = true;
    });
    try {
      if (isRegister) {
        await auth.register(email, pass);
      } else {
        await auth.signIn(email, pass);
      }
      if (mounted) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isRegister ? 'Registered' : 'Signed in')));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          error = 'Auth failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isRegister ? 'Register' : 'Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: emailCtl,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: passCtl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            const SizedBox(height: 12),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loading ? null : _submit,
              child: Text(loading
                  ? 'Please wait'
                  : (isRegister ? 'Create Account' : 'Sign In')),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isRegister = !isRegister;
                  error = '';
                });
              },
              child: Text(isRegister
                  ? 'Have an account? Sign in'
                  : 'No account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
