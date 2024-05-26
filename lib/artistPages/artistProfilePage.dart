import 'package:skeletonizer/skeletonizer.dart';
import 'package:comsart/auth.dart';
import 'package:comsart/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:shimmer/shimmer.dart' as ShimmerEffect;
import 'package:skeletonizer/src/effects/shimmer_effect.dart' as ShimmerEffect;

class ArtistProfilePage extends StatefulWidget {
  const ArtistProfilePage({super.key});

  @override
  State<ArtistProfilePage> createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {
  String verify = '';

  var artist = {};
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkVerify();
    _getArtist();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkVerify() async {
    final getVerify = await Store().getVerify();

    setState(() {
      verify = getVerify;
    });
  }

  Future<void> _getArtist() async {
    final getArtist = await AuthMethods().getUser();

    if (getArtist['ok'] == false) {
      Navigator.pushNamed(context, '/login');
    }
    setState(() {
      artist = getArtist['data'];
    });
  }

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
          child: Skeletonizer(
            enabled: artist.isEmpty || _isLoading,
            effect: const ShimmerEffect.ShimmerEffect(
              duration: Duration(seconds: 4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child:Skeleton.replace(
                    width: 170,
                    height: 170,
                    child:  Image.network(
                    '${dotenv.env['API_URL']}/${artist['profile_image']}',
                    width: 170,
                    height: 170,
                    fit: BoxFit.cover,
                  )),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        style: ShadTheme.of(context).textTheme.h2,
                        artist['name'].toString(),
                        textAlign: TextAlign.left),
                    const Padding(padding: EdgeInsets.only(right: 5)),
                    if (verify == 'approved')
                      const Icon(
                        LucideIcons.badgeCheck,
                        color: Color.fromARGB(255, 91, 179, 54),
                        size: 22,
                      ),
                  ],
                ),
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
                      Skeleton.leaf(
                          child: CircleAvatar(
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
                      )),
                      const Padding(padding: EdgeInsets.only(right: 10)),
                      Text(
                        'Verify',
                        style: ShadTheme.of(context).textTheme.large,
                      ),
                      const Spacer(),
                      Skeleton.leaf(
                          child: ShadButton.outline(
                        width: 32,
                        height: 32,
                        icon: const Icon(
                          LucideIcons.chevronRight,
                          size: 14,
                          color: Color(0xfffa9c05),
                        ),
                        // border: Border.all(color: Colors.transparent, width: 1),
                        backgroundColor:
                            const Color.fromARGB(68, 181, 181, 182),
                        size: ShadButtonSize.icon,
                        onPressed: () {
                          Navigator.pushNamed(context, '/verify');
                        },
                      )),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
