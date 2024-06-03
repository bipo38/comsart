import 'package:comsart/Widgets/NavbarArtist.dart';
import 'package:comsart/routes/router.dart';
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
      routerConfig.go('/login');
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
      bottomNavigationBar: const NavbarArtist(index: 2),
      body: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Skeletonizer(
            enabled: artist.isEmpty || _isLoading,
            effect: const ShimmerEffect.ShimmerEffect(
              duration: Duration(seconds: 4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Skeleton.replace(
                        width: 170,
                        height: 170,
                        child: Image.network(
                          '${dotenv.env['API_URL']}/${artist['profile_image']}',
                          width: 170,
                          height: 170,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        style: ShadTheme.of(context).textTheme.h2,
                        artist['name'].toString(),
                        textAlign: TextAlign.center),
                    const Padding(padding: EdgeInsets.only(right: 5)),
                    if (verify == 'approved')
                      const Icon(
                        LucideIcons.badgeCheck,
                        color: Color.fromARGB(255, 91, 179, 54),
                        size: 22,
                      ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
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
                    routerConfig.go('/home/profile/verify');
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
                            routerConfig.go('/home/profile/verify');
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
                          routerConfig.go('/home/profile/verify');
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
