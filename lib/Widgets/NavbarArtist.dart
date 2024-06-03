import 'package:comsart/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NavbarArtist extends StatelessWidget {
  final int index;
  const NavbarArtist({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.brush),
          label: 'Commissions',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(LucideIcons.shoppingCart),
        //   label: 'Cart',
        // ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.user),
          label: 'Profile',
        ),
      ],
      onTap: (int index) {
        if (index == 0) {
          routerConfig.replace('/home');
        } else if (index == 1) {
          routerConfig.go('/home/artist');
        } else if (index == 2) {
          return;
        } else if (index == 3) {
          routerConfig.go('/home/profile');
        }
      },
      selectedIconTheme: const IconThemeData(color: Color(0xFFdd4c4f)),
      selectedItemColor: const Color(0xFFdd4c4f),
      currentIndex: index,
      unselectedIconTheme:
          const IconThemeData(color: Color.fromARGB(255, 120, 122, 125)),
      unselectedItemColor: const Color.fromARGB(255, 120, 122, 125),
      showUnselectedLabels: false,
      showSelectedLabels: false,
    );
  }
}
