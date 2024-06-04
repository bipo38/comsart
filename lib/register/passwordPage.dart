import 'package:comsart/auth.dart';
import 'package:comsart/register/registerStore.dart';
import 'package:comsart/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  final formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Comsart'),
          centerTitle: true,
          backgroundColor: const Color(0xFFf8fafc),
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ShadImage(
              'assets/img/pass.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
              alignment: Alignment.topLeft,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: ShadForm(
                key: formKey,
                child: Column(children: [
                  ShadInputFormField(
                    controller: passwordController,
                    label: Text(
                      'Password',
                      style: ShadTheme.of(context).textTheme.h3,
                    ),
                    placeholder: const Text('Enter your password'),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (v) {
                      if (v.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  ShadInputFormField(
                    controller: passwordConfirmationController,
                    placeholder: const Text('Enter your password again'),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (v) {
                      if (v.isEmpty) {
                        return 'Password confirmation is required';
                      }
                      if (v != passwordController.text) {
                        return 'Password confirmation does not match';
                      }
                      return null;
                    },
                  ),
                  ShadButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        RegisterStore().setPassword(passwordController.text);
                        RegisterStore().setConfirmPassword(
                            passwordConfirmationController.text);

                        var response = await AuthMethods().registerLaravel(
                            await RegisterStore().getUsername(),
                            await RegisterStore().getEmail(),
                            await RegisterStore().getPassword(),
                            await RegisterStore().getConfirmPassword(),
                            await RegisterStore().getRole(),
                            await RegisterStore().getProfileImage());

                        if (!mounted) return;

                        if (response) {
                          routerConfig.go('/home');
                        }
                      }
                    },
                    text: const Text('Sign Up'),
                    hoverBackgroundColor: const Color(0xFFe74c3c),
                    backgroundColor: const Color(0xFFdd4c4f),
                    width: double.infinity,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        LucideIcons.send,
                        size: 14,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
