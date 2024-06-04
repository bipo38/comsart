import 'package:comsart/register/registerStore.dart';
import 'package:comsart/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UsernamePage extends StatefulWidget {
  const UsernamePage({super.key});

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final usernameController = TextEditingController();

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
              'assets/img/user1.png',
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
                    controller: usernameController,
                    label: Text(
                      'Username',
                      style: ShadTheme.of(context).textTheme.h3,
                    ),
                    placeholder: const Text('Enter your username'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  ShadButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        RegisterStore().setUsername(usernameController.text);
                        routerConfig.go(
                            '/register/email/registerOption/name/profileImage');
                      }
                    },
                    text: const Text('Continue'),
                    hoverBackgroundColor: const Color(0xFFe74c3c),
                    backgroundColor: const Color(0xFFdd4c4f),
                    width: 360,
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
