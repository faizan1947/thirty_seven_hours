import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _pass,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter Password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final pass = _pass.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: pass);
                        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  //print('Weak Password');
                } else if (e.code == 'email-already-in-use') {
                  //print('Email already in use');
                } else if (e.code == 'invalid-email') {
                  //print('Invalid Email');
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login/', (route) => false);
            },
            child: const Text('Already registered use? Login here'),
          ),
        ],
      ),
    );
  }
}
