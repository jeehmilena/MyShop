import 'package:flutter/material.dart';
import 'package:my_shop/exceptions/auth_exceptions.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;
  final passwordController = TextEditingController();
  final Map<String, String> authData = {'email': '', 'password': ''};
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AnimationController? animationController;
  Animation<Size>? heightAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    heightAnimation = Tween(
      begin: const Size(double.infinity, 310),
      end: const Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Curves.linear,
      ),
    );

    //heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
  }

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

    try {
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
    } on AuthException catch (error) {
      showErrorDialog(error.toString());
    } catch (error) {
      showErrorDialog('an unexpected error occurred');
    }

    setState(() => isLoading = false);
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Ops!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
    );
  }

  void switchAuthMode() {
    setState(() {
      if (isLogin()) {
        _authMode = AuthMode.Signup;
        animationController?.forward();
      } else {
        _authMode = AuthMode.Login;
        animationController?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedBuilder(
        animation: heightAnimation!,
        builder: (ctx, childForm) => Container(
          padding: const EdgeInsets.all(16),
          height: heightAnimation?.value.height ?? (isLogin() ? 320 : 400),
          width: deviceSize.width * 0.75,
          child: childForm,
        ),
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
