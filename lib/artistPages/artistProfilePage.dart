import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ArtistProfilePage extends StatefulWidget {
  const ArtistProfilePage({super.key});

  @override
  State<ArtistProfilePage> createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {
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
            Navigator.popAndPushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.popAndPushNamed(context, '/commissions');
          } else if (index == 2) {
            Navigator.popAndPushNamed(context, '/profile');
          }
        },
        selectedIconTheme: const IconThemeData(color: Color(0xFFdd4c4f)),
        selectedItemColor: const Color(0xFFdd4c4f),
        currentIndex: 2,
        unselectedIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 120, 122, 125)),
        unselectedItemColor: const Color.fromARGB(255, 120, 122, 125),
        //remove the hover effect
        showUnselectedLabels: false,
        showSelectedLabels: false,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset(
                'assets/img/mob.png',
                height: 160,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 15)),
            Text(
                style: ShadTheme.of(context).textTheme.h2,
                'Palmeras',
                textAlign: TextAlign.left),
            const Padding(padding: EdgeInsets.only(bottom: 50)),
            Text(
              'Profile',
              textAlign: TextAlign.left,
              style: ShadTheme.of(context).textTheme.large,
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                Navigator.pushNamed(context, '/verify');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: const Color(0xfffdd79b),
                    child: IconButton(
                      icon: const Icon(
                        LucideIcons.badgeCheck,
                        color: Color(0xfffa9c05),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/verify');
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                  Text(
                    'Verify',
                    style: ShadTheme.of(context).textTheme.large,
                  ),
                  const Spacer(),
                  ShadButton.outline(
                    width: 32,
                    height: 32,
                    icon: const Icon(
                      LucideIcons.chevronRight,
                      size: 14,
                      color: Color(0xfffa9c05),
                    ),
                    // border: Border.all(color: Colors.transparent, width: 1),
                    backgroundColor: Color.fromARGB(68, 181, 181, 182),
                    size: ShadButtonSize.icon,
                    onPressed: () {
                      Navigator.pushNamed(context, '/verify');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
