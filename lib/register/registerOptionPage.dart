import 'package:comsart/register/registerStore.dart';
import 'package:comsart/register/usernamePage.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterOptionScreen extends StatefulWidget {
  const RegisterOptionScreen({super.key});

  @override
  State<RegisterOptionScreen> createState() => _RegisterOptionScreenState();
}

class _RegisterOptionScreenState extends State<RegisterOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          const Image(image: AssetImage('assets/img/options.png'), height: 200),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(style: ShadTheme.of(context).textTheme.h3, 'Who are you?'),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          ShadButton(
            text: const Text('User'),
            hoverBackgroundColor: const Color(0xFFe74c3c),
            backgroundColor: const Color(0xFFdd4c4f),
            width: 300,
            icon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                LucideIcons.user,
                size: 14,
              ),
            ),
            onPressed: () {
              RegisterStore().setRole('user');
              Navigator.pushNamed(context, '/username');
            },
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          ShadButton(
            text: const Text('Artist'),
            hoverBackgroundColor: const Color(0xFFe74c3c),
            backgroundColor: const Color(0xFFdd4c4f),
            width: 300,
            icon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                LucideIcons.brush,
                size: 14,
              ),
            ),
            onPressed: () {
              RegisterStore().setRole('artist');

              Navigator.pushNamed(
                context,
                '/username'
              );
            },
          ),
        ],
      )),
    );
  }
}
