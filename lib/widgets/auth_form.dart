import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.Login;
  final passwordController = TextEditingController();
  final Map<String, String> authData = {'email': '', 'password': ''};
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool isLogin() => _authMode == AuthMode.Login;
  bool isSignup() => _authMode == AuthMode.Signup;

  Future<void> submit() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => isLoading = true);
    formKey.currentState?.save();
    AuthModel authModel = Provider.of(context, listen: false);

    if (isLogin()) {
      await authModel.signInWithPassword(
        authData['email']!,
        authData['password']!,
      );
    } else {
      await authModel.signUp(
        authData['email']!,
        authData['password']!,
      );
    }

    setState(() => isLoading = false);
  }

  void switchAuthMode() {
    setState(() {
      if (isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: isLogin() ? 320 : 400,
        width: deviceSize.width * 0.75,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Please provide a valid email.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: passwordController,
                onSaved: (password) => authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Please provide a valid password.';
                  }
                  return null;
                },
              ),
              if (isSignup())
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != passwordController.text) {
                            return 'The passwords entered are different.';
                          }
                          return null;
                        },
                ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      )),
                  child: Text(isLogin() ? 'ENTER' : 'REGISTER'),
                ),
              const Spacer(),
              TextButton(
                onPressed: switchAuthMode,
                child: Text(
                  isLogin()
                      ? 'Do you want to register?'
                      : 'Already have an account?',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.pinkAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
