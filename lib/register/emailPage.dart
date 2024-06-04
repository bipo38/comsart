import 'package:comsart/auth.dart';
import 'package:comsart/register/registerStore.dart';
import 'package:comsart/routes/router.dart';
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
  var isEmailRepeat = false;
  var emailCheckVerifyMsg = '';

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
              'assets/img/email3.png',
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
                    controller: emailController,
                    label: Text(
                      'Email',
                      style: ShadTheme.of(context).textTheme.h3,
                    ),
                    placeholder: const Text('Enter your email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v.isEmpty || !v.contains('@') || !v.contains('.')) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  ShadButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        var response = await AuthMethods()
                            .checkEmail(emailController.text);

                        if (response['ok'] == false) {
                          setState(() {
                            emailCheckVerifyMsg = response['message'];
                            isEmailRepeat = true;
                          });
                          return;
                        }
                        RegisterStore().setEmail(emailController.text);
                        setState(() {
                          isEmailRepeat = false;
                        });
                        routerConfig.go('/register/email/registerOption');
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
            if (isEmailRepeat)
              Text(
                emailCheckVerifyMsg,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
