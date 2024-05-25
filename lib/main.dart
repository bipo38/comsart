import 'package:comsart/artistPages/artistProfilePage.dart';
import 'package:comsart/artistPages/artistVerificationPage.dart';
import 'package:comsart/auth.dart';
import 'package:comsart/register/emailPage.dart';
import 'package:comsart/register/registerOptionPage.dart';
import 'package:comsart/userPages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_lucide/flutter_lucide.dart' as lucide;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

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
          textTheme: ShadTextTheme.fromGoogleFont(
            GoogleFonts.poppins,
          ),
          brightness: Brightness.dark,
          colorScheme: const ShadSlateColorScheme.light(
            background: Color(0xFFf8fafc),
          )),
      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) => const ArtistProfilePage(),
        '/home': (context) => const HomePageUser(),
        '/verify': (context) => const ArtistVerificationPage(),
      },
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

  final primaryColor = const Color(0xFFdd4c4f);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Comsart'),
        centerTitle: true,
        backgroundColor: const Color(0xFFf8fafc),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/img/logo.png'), width: 200),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      style: TextStyle(
                        color: Color(0xFF6c757d),
                      ),
                      'Don\'t have an account? ',
                      textAlign: TextAlign.center,
                    ),
                    ShadButton.link(
                      padding: const EdgeInsets.all(0),
                      text: const Text('Login here.'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmailPage()),
                        );
                      },
                    ),
                  ],
                ),
                ShadButton(
                  onPressed: () async {
                    if (formKey.currentState!.saveAndValidate()) {
                      var response = await AuthMethods().loginLaravel(
                        emailController.text,
                        passwordController.text,
                      );

                      if (response) {
                        setState(() {
                          loginSuccess = 1;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePageUser()),
                        );

                        // Navigator.pop(context);
                      } else {
                        setState(() {
                          loginSuccess = 2;
                        });
                      }
                    }
                  },
                  text: const Text('Sign in'),
                  hoverBackgroundColor: const Color(0xFFe74c3c),
                  backgroundColor: primaryColor,
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
