import 'package:comsart/artistRegisterPage.dart';
import 'package:comsart/userRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterOptionScreen extends StatefulWidget {
  const RegisterOptionScreen({Key? key}) : super(key: key);

  @override
  _RegisterOptionScreenState createState() => _RegisterOptionScreenState();
}

class _RegisterOptionScreenState extends State<RegisterOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shadcn UI Example'),
      ),
      body: Center(
          child: Column(
        children: [
          ShadButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserRegisterPage()),
              );
            },
            text: const Text('User'),
            hoverBackgroundColor: Colors.blue[700],
            backgroundColor: Colors.blue,
            width: 200,
            icon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                LucideIcons.user,
                size: 14,
              ),
            ),
          ),
          ShadButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ArtistRegisterPage()),
              );
            },
            text: const Text('Artist'),
            hoverBackgroundColor: Colors.blue[700],
            backgroundColor: Colors.blue,
            width: 200,
            icon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                LucideIcons.brush,
                size: 14,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
