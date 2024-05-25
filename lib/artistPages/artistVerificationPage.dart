import 'package:comsart/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:twitter_login/twitter_login.dart';

class ArtistVerificationPage extends StatefulWidget {
  const ArtistVerificationPage({super.key});

  @override
  State<ArtistVerificationPage> createState() => _ArtistVerificationPageState();
}

class _ArtistVerificationPageState extends State<ArtistVerificationPage> {
  final popoverController = ShadPopoverController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Comsart'),
        centerTitle: true,
        backgroundColor: const Color(0xFFf8fafc),
        // automaticallyImplyLeading: false
      ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                // child: Icon(LucideIcons.badgeCheck,
                //     size: 200, color: Color.fromARGB(68, 181, 181, 182)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Artist Verification',
                style: ShadTheme.of(context).textTheme.h3,
              ),
              ShadPopover(
                  controller: popoverController,
                  child: ShadButton.ghost(
                    icon: const Icon(LucideIcons.info),
                    onPressed: popoverController.toggle,
                  ),
                  popover: (context) => SizedBox(
                        width: 300,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'This verification serves to use fully the features of the app, due to avoid any frauds, you will need to connect your twitter, we will check the request manually, if is approved you will be able to use the app fully.Thank you for your understanding.',
                              style: ShadTheme.of(context).textTheme.muted,
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                      ))
            ])),
            Center(
              child: ShadButton(
                onPressed: () async {


                  final identifier = dotenv.env['TWITTER_API_KEY']!;
                  final secret = dotenv.env['TWITTER_API_KEY_SECRET']!;

              

                  final twitterLogin = TwitterLogin(
                    // Consumer API keys
                    apiKey: identifier,
                    // Consumer API Secret keys
                    apiSecretKey: secret,
                   
                    redirectURI: 'comsart://',
                  );
                  final authResult = await twitterLogin.login();
                  print(authResult.status);
                 
                },
                text: const Text('Verify your account'),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    LucideIcons.twitter,
                    size: 16,
                  ),
                ),
                hoverBackgroundColor: const Color.fromARGB(255, 20, 107, 161),
                backgroundColor: const Color(0xFF1DA1F2),
                width: 300,
              ),
            )
          ],
        ),
      ),
    );
  }
}
