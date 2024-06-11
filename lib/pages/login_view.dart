import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/supabase.dart';

//
class LoginView extends StatefulWidget {
  static const routeName = loginRoute;
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    listenToAuthState(setState, _userId, context, 'toHome');
  }

  Future<void> _signInWithGoogle() async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await googleSignInNative();
      } else {
        await webGoogleSignIn();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(loginPageTitle),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: Image.asset(
            'assets/images/google.png',
            width: 28,
          ),
          onPressed: _signInWithGoogle,
          label: const Text(signInWithGoogle),
        ),
      ),
    );
  }
}
