import 'package:comsart/auth.dart';
import 'package:comsart/register/registerStore.dart';
import 'package:comsart/store.dart';
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
            const Image(image: AssetImage('assets/img/one.png'), height: 200),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: ShadForm(
                key: formKey,
                child: Column(children: [
                  ShadInputFormField(
                    controller: passwordController,
                    label: const Text('Password'),
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
                    label: const Text('Confirm Password'),
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

                        final navigator = Navigator.of(context);

                        var response = await AuthMethods().registerLaravel(
                            await RegisterStore().getUsername(),
                            await RegisterStore().getEmail(),
                            await RegisterStore().getPassword(),
                            await RegisterStore().getConfirmPassword(),
                            await RegisterStore().getRole());

                        if (!mounted) return;

                        if (response) {
                          navigator.pop();
                        }
                      }
                    },
                    text: const Text('Sign Up'),
                    hoverBackgroundColor: const Color(0xFFe74c3c),
                    backgroundColor: const Color(0xFFdd4c4f),
                    width: 300,
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
