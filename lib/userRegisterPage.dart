import 'package:comsart/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_lucide/flutter_lucide.dart' as lucide;

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  Map<Object, dynamic> formValue = {};
  final formKey = GlobalKey<ShadFormState>();
  var registerSuccess = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Register'),
      ),
      body: Center(
        child: Column(
          children: [
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: ShadForm(
                    key: formKey,
                    child: Column(
                      children: [
                        ShadInputFormField(
                          controller: emailController,
                          label: const Text('Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v.isEmpty ||
                                !v.contains('@') ||
                                !v.contains('.')) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                        ShadInputFormField(
                          controller: nameController,
                          label: const Text('Name'),
                          keyboardType: TextInputType.name,
                          description:
                              const Text('We recommend using the artist name.'),
                          validator: (v) {
                            if (v.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        ShadInputFormField(
                          controller: passwordController,
                          label: const Text('Password'),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (v) {
                            if (v.isEmpty) {
                              return 'Password is required';
                            }

                            if (passwordController.text !=
                                passwordConfirmationController.text) {
                              return 'Password and Password Confirmation must be the same';
                            }

                            return null;
                          },
                        ),
                        ShadInputFormField(
                          controller: passwordConfirmationController,
                          label: const Text('Password Confirmation'),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (v) {
                            if (v.isEmpty) {
                              return 'Password Confirmation is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ))),
            Column(
              children: [
                ShadButton(
                  onPressed: () async {
                    if (formKey.currentState!.saveAndValidate()) {
                      var response = await AuthMethods().registerLaravel(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                          passwordConfirmationController.text,
                          'user');

                      if (response['body']['token'] != null) {
                        setState(() {
                          registerSuccess = 1;
                        });

                        Navigator.pop(context);
                      } else {
                        setState(() {
                          registerSuccess = 2;
                        });
                      }
                    }
                  },
                  text: const Text('Register'),
                  hoverBackgroundColor: Colors.blue[700],
                  backgroundColor: Colors.blue,
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      lucide.LucideIcons.send,
                      size: 14,
                    ),
                  ),
                ),
                if (registerSuccess == 1)
                  const Text('Registration successful!',
                      style: TextStyle(color: Colors.green))
                else if (registerSuccess == 2)
                  const Text('Registration failed!',
                      style: TextStyle(color: Colors.red))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
