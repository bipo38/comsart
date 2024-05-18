import 'package:comsart/auth.dart';
import 'package:comsart/registerOptionPage.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_lucide/flutter_lucide.dart' as lucide;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// void main() {
// }

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      darkTheme: ShadThemeData(
          brightness: Brightness.dark,
          colorScheme: const ShadSlateColorScheme.light()),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Map<Object, dynamic> formValue = {};
  final formKey = GlobalKey<ShadFormState>();
  var loginSuccess = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                          controller: passwordController,
                          label: const Text('Password'),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (v) {
                            if (v.isEmpty) {
                              return 'Password is required';
                            }

                            return null;
                          },
                        ),
                      ],
                    ))),
            Column(
              children: [
                //have account text make it clickable
                ShadButton.link(
                  text: const Text('Already have an account? Login here.'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterOptionScreen()),
                    );
                  },
                ),
                ShadButton(
                  onPressed: () async {
                    if (formKey.currentState!.saveAndValidate()) {
                      var response = await AuthMethods().loginLaravel(
                        emailController.text,
                        passwordController.text,
                      );

                      if (response['body']['token'] != null) {
                        setState(() {
                          loginSuccess = 1;
                        });

                        // Navigator.pop(context);
                      } else {
                        setState(() {
                          loginSuccess = 2;
                        });
                      }
                    }
                  },
                  text: const Text('Login'),
                  hoverBackgroundColor: Colors.blue[700],
                  backgroundColor: Colors.blue,
                  width: 300,
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      lucide.LucideIcons.send,
                      size: 14,
                    ),
                  ),
                ),
                if (loginSuccess == 1)
                  const Text('Login successful!',
                      style: TextStyle(color: Colors.green))
                else if (loginSuccess == 2)
                  const Text('Login failed!',
                      style: TextStyle(color: Colors.red))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
