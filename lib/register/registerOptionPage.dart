import 'package:comsart/register/registerStore.dart';
import 'package:comsart/routes/router.dart';
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
          const ShadImage(
            'assets/img/whoa.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
            alignment: Alignment.topLeft,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Text(
                      'Who you are?',
                      style: ShadTheme.of(context).textTheme.h3,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                ShadButton(
                  text: const Text('User'),
                  hoverBackgroundColor: const Color(0xFFe74c3c),
                  backgroundColor: const Color(0xFFdd4c4f),
                  width: double.infinity,
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      LucideIcons.user,
                      size: 14,
                    ),
                  ),
                  onPressed: () {
                    RegisterStore().setRole('user');
                    routerConfig.go('/register/email/registerOption/name');
                  },
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                ShadButton(
                  text: const Text('Artist'),
                  hoverBackgroundColor: const Color(0xFFe74c3c),
                  backgroundColor: const Color(0xFFdd4c4f),
                  width: double.infinity,
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      LucideIcons.brush,
                      size: 14,
                    ),
                  ),
                  onPressed: () {
                    RegisterStore().setRole('artist');
                    routerConfig.go('/register/email/registerOption/name');
                  },
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
