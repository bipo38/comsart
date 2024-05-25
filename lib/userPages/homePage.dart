import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Comsart'),
          centerTitle: true,
          backgroundColor: const Color(0xFFf8fafc),
          automaticallyImplyLeading: false),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.brush),
            label: 'Commissions',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/commissions');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        selectedIconTheme: const IconThemeData(color: Color(0xFFdd4c4f)),
        selectedItemColor: const Color(0xFFdd4c4f),
        currentIndex: 0,
        unselectedIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 120, 122, 125)),
        unselectedItemColor: const Color.fromARGB(255, 120, 122, 125),
        //remove the hover effect
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('Hola')],
        ),
      ),
    );
  }
}
