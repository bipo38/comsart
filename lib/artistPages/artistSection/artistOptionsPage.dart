import 'package:comsart/Widgets/CardOptions.dart';
import 'package:comsart/Widgets/NavbarArtist.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/effects/shimmer_effect.dart' as ShimmerEffect;

class ArtistOptionsPage extends StatefulWidget {
  const ArtistOptionsPage({super.key});

  @override
  State<ArtistOptionsPage> createState() => _ArtistOptionsPageState();
}

class _ArtistOptionsPageState extends State<ArtistOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: const Text('Comsart'),
          centerTitle: true,
          backgroundColor: const Color(0xFFf8fafc),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: const NavbarArtist(index: 1),
        body: Skeletonizer(
            enabled: false,
            effect: const ShimmerEffect.ShimmerEffect(
              duration: Duration(seconds: 4),
            ),
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Artist Options',
                      style: ShadTheme.of(context).textTheme.h2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      children: const [
                        CardOption(
                            title: 'Paints',
                            imageRoute: 'assets/img/paints.png',
                            route: '/home/artist/paints'),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
