import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/login_provider.dart';
import 'package:to_do_app/widgets/cus_text_field.dart';
import 'package:to_do_app/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Card(
          elevation: 10,
          child: SizedBox(
            width: 500,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                CusTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                ),
                CusTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                Stack(
                  children: [
                    CustomButton(
                      label: 'Submit',
                      color: Colors.purpleAccent,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      onPressed: () async {
                        final loginProvider = context.read<LoginProvider>();
                        await loginProvider.login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        if (!context.mounted) return;
                        if (loginProvider.isLoggedIn) {
                          context.go('/home');
                        }
                      },
                    ),
                    if (context.watch<LoginProvider>().isLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black45,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
