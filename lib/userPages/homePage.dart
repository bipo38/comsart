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
            // title: const Text('Comsart'),
            centerTitle: true,
            backgroundColor: const Color(0xFFf8fafc),
            automaticallyImplyLeading: false),
        bottomNavigationBar: const NavbarArtist(
          index: 0,
        ), // Substitute in future for NavbarUser()
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              children: [
                Text(
                  'Comsart',
                  style: ShadTheme.of(context).textTheme.h2,
                ),
                const Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                ),
                Skeletonizer(
                    enabled: _isLoading,
                    child: Align(
                      alignment: Alignment.center,
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 0.65,
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        children: [
                          if (_isLoading) const CircularProgressIndicator(),
                          if (paints.isNotEmpty)
                            for (var paint in paints)
                              Container(
                                // padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        routerConfig.go('/home/${paint['id']}');
                                      },
                                      child: Container(
                                        // width: 200,
                                        padding: const EdgeInsets.all(10),
                                        // decoration: const BoxDecoration(
                                        //   color: Colors.white,
                                        //   boxShadow: [
                                        //     BoxShadow(
                                        //       color: Colors.grey,
                                        //       blurRadius: 2.0,
                                        //     ),
                                        //   ],
                                        // ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                style: ShadTheme.of(context)
                                                    .textTheme
                                                    .h4),
                                            const Padding(
                                              padding: EdgeInsets.only(top: 0),
                                            ),
                                            Text(
                                                paint['format']
                                                    .toString()
                                                    .capitalize(),
                                                style: ShadTheme.of(context)
                                                    .textTheme
                                                    .p),
                                            // const Padding(
                                            //   padding: EdgeInsets.only(top: 5),
                                            // ),
                                            // Container(
                                            //     color: const Color.fromARGB(
                                            //         111, 124, 124, 124),
                                            //     height: 1,
                                            //     width: double.infinity),
                                            // const Padding(
                                            //   padding: EdgeInsets.only(top: 5),
                                            // ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text('${paint['price']} €',
                                                    style: ShadTheme.of(context)
                                                        .textTheme
                                                        .p),
                                                // ShadButton(
                                                //   icon: const Icon(
                                                //     LucideIcons.shoppingCart,
                                                //     size: 16,
                                                //   ),
                                                //   backgroundColor:
                                                //       const Color(0xFFdd4c4f),
                                                //   hoverBackgroundColor:
                                                //       const Color.fromARGB(
                                                //           255, 221, 105, 107),
                                                //   size: ShadButtonSize.icon,
                                                //   onPressed: () {},
                                                // ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    // const Padding(
                                    //   padding: EdgeInsets.only(left: 10),
                                    // ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
