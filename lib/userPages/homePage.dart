import 'dart:ui';

import 'package:comsart/Widgets/NavbarArtist.dart';
import 'package:comsart/artistPages/artistPaints/edit_paint_page.dart';
import 'package:comsart/http/user_http.dart';
import 'package:comsart/routes/router.dart';
import 'package:comsart/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_lucide/flutter_lucide.dart' as LucideIcons;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  var paints = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPaints();
  }

  Future<void> _getPaints() async {
    final getPaints = await UserHttp().getAllPaints();
    final isLogged = await Store().isLoggedIn();

    print(getPaints);

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
            title: Text(
              'Comsart',
              style: ShadTheme.of(context).textTheme.h2,
            ),
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            backgroundColor: const Color(0xFFf8fafc),
            automaticallyImplyLeading: false),
        bottomNavigationBar: const NavbarArtist(
          index: 0,
        ), // Substitute in future for NavbarUser()
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
              ),
              if (_isLoading)
                LoadingAnimationWidget.inkDrop(
                  color: const Color(0xFFe74c3c),
                  size: 50,
                ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                childAspectRatio: 0.75,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                children: [
                  if (paints.isNotEmpty)
                    for (var paint in paints)
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              routerConfig.go('/home/${paint['id']}');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ShadImage(
                                      '${dotenv.env['API_URL']}/${paint['images'][0]}',
                                      // width: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      height: 130,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10),
                                  ),
                                  Text(paint['title'],
                                      style:
                                          ShadTheme.of(context).textTheme.h4),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 0),
                                  ),
                                  Text(paint['format'].toString().capitalize(),
                                      style: ShadTheme.of(context)
                                          .textTheme
                                          .muted),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${paint['price'].toStringAsFixed(2).toString().replaceAll('.', ',')} €',
                                          style: ShadTheme.of(context)
                                              .textTheme
                                              .p),
                                      ShadButton.outline(
                                          size: ShadButtonSize.sm,
                                          // backgroundColor:
                                          //     const Color(0xFFe74c3c),
                                          onPressed: () {
                                            showShadDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ShadDialog(
                                                      content: Container(
                                                        width: 300,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: ShadImage(
                                                                '${dotenv.env['API_URL']}/${paint['images'][0]}',
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 200,
                                                              ),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10)),

                                                            Text(
                                                              paint['title'],
                                                              style: ShadTheme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .h2,
                                                            ),
                                                            Text(
                                                              paint[
                                                                  'description'],
                                                              style: ShadTheme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .p,
                                                            ),

                                                            // Expanded(
                                                            //   child: Flexible(
                                                            //     child:
                                                            //         Container(
                                                            //       width: double
                                                            //           .infinity,
                                                            //       padding:
                                                            //           const EdgeInsets
                                                            //               .only(
                                                            //               top:
                                                            //                   10),
                                                            //       child: Text(
                                                            //         paint[
                                                            //             'description'],
                                                            //         style: ShadTheme.of(
                                                            //                 context)
                                                            //             .textTheme
                                                            //             .p,
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            Text(
                                                              'Format: ${paint['format'].toString().capitalize()}',
                                                              style: ShadTheme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .muted,
                                                            ),
                                                            Text(
                                                              'Price: ${paint['price'].toStringAsFixed(2).toString().replaceAll('.', ',')} €',
                                                              style: ShadTheme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .p,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                          },
                                          icon: const Icon(
                                              LucideIcons.LucideIcons.eye)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ],
          ),
        ));
  }
}
