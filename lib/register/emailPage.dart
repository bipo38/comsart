import 'package:comsart/register/registerOptionPage.dart';
import 'package:comsart/register/registerStore.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final emailController = TextEditingController();

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
                    controller: emailController,
                    label: const Text('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v.isEmpty || !v.contains('@') || !v.contains('.')) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  ShadButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        RegisterStore().setEmail(emailController.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterOptionScreen()));
                      }
                    },
                    text: const Text('Continue'),
                    hoverBackgroundColor: const Color(0xFFe74c3c),
                    backgroundColor: const Color(0xFFdd4c4f),
                    width: 300,
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
