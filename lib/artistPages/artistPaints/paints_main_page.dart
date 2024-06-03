import 'package:comsart/Widgets/CardArtistPaint.dart';
import 'package:comsart/Widgets/NavbarArtist.dart';
import 'package:comsart/http/paints.dart';
import 'package:comsart/routes/router.dart';
import 'package:comsart/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/effects/shimmer_effect.dart' as ShimmerEffect;

class PaintsMainPage extends StatefulWidget {
  const PaintsMainPage({super.key});

  @override
  State<PaintsMainPage> createState() => _PaintsMainPageState();
}

class _PaintsMainPageState extends State<PaintsMainPage> {
  var paints = [];
  var _isLoading = true;
  var error = '';

  @override
  void initState() {
    super.initState();
    _getPaints();
  }

  Future<void> _getPaints() async {
    final getPaints = await Paints().getPaints();
    final isLogged = await Store().isLoggedIn();

    if (isLogged == false) {
      routerConfig.go('/login');
    }

    if (getPaints['ok'] == false) {
      routerConfig.go('/login');
      return;
    }
    setState(() {
      paints = getPaints['data']['paints'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          backgroundColor: const Color(0xFFf8fafc),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: const NavbarArtist(index: 1),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Skeletonizer(
                enabled: _isLoading,
                effect: const ShimmerEffect.ShimmerEffect(
                  duration: Duration(seconds: 4),
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Paints',
                          style: ShadTheme.of(context).textTheme.h2,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 0),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Skeleton.leaf(
                                    child: ShadButton(
                                      onPressed: () {
                                        routerConfig
                                            .go('/home/artist/paints/new');
                                      },
                                      text: const Text('New Paint'),
                                      icon: const Icon(LucideIcons.plus),
                                      backgroundColor: const Color(0xFFdd4c4f),
                                      width: 150,
                                      height: 40,
                                    ),
                                  )),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              for (var paint in paints)
                                Column(
                                  children: [
                                    CardArtistPaint(
                                      paint: paint,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 10)),
                                  ],
                                ),
                              if (_isLoading == false && paints.isEmpty)
                                Column(
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(top: 90)),
                                    const ShadImage(
                                      'assets/img/practice.png',
                                      width: 200,
                                      height: 200,
                                    ),
                                    Text(
                                      'No paints yet',
                                      style: ShadTheme.of(context).textTheme.h4,
                                    ),
                                  ],
                                )
                            ],
                          )),
                    ],
                  ),
                ))));
  }
}
