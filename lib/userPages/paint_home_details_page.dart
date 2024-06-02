import 'package:comsart/artistPages/artistPaints/edit_paint_page.dart';
import 'package:comsart/http/paints.dart';
import 'package:comsart/http/user_http.dart';
import 'package:comsart/routes/router.dart';
import 'package:comsart/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_lucide/flutter_lucide.dart' as LucideIcons;
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PaintHomeDetailsPage extends StatefulWidget {
  final String id;

  const PaintHomeDetailsPage({super.key, required this.id});

  @override
  State<PaintHomeDetailsPage> createState() => _PaintHomeDetailsPageState();
}

class _PaintHomeDetailsPageState extends State<PaintHomeDetailsPage> {
  var paint = {};
  var _isLoading = true;
  var error = '';

  @override
  void initState() {
    super.initState();
    _getPaint();
  }

  Future<void> _getPaint() async {
    final getPaint = await Paints().getPaint(widget.id);
    final isLogged = await Store().isLoggedIn();
    if (isLogged == false) {
      routerConfig.go('/login');
    }
    if (getPaint['ok'] == false) {
      setState(() {
        error = getPaint['data'];
      });
      routerConfig.go('/paints');
      return;
    }

    setState(() {
      paint = getPaint['data']['paint'];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 10,
        backgroundColor: const Color(0xFFf8fafc),
        // leading: IconButton(
        //   icon: const Icon(
        //     LucideIcons.LucideIcons.chevron_left,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     routerConfig.go('/home');
        //   },
        // ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -5), // changes position of shadow
            ),
          ],
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(30),
          //   topRight: Radius.circular(30),
          // ),
        ),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadButton(
              width: 300,
              backgroundColor: const Color(0xFFdd4c4f),
              hoverBackgroundColor: const Color.fromARGB(255, 166, 62, 64),
              height: 50,
              decoration: const ShadDecoration(),
              text: const Text(
                'Buy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                if (paint.isEmpty && _isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (paint.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: ShadImage(
                          '${dotenv.env['API_URL']}/${paint['images'][0]}',
                          width: double.infinity,
                          height: 350,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              paint['title'],
                              style: ShadTheme.of(context).textTheme.h2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              paint['format'].toString().capitalize(),
                              style: ShadTheme.of(context).textTheme.muted,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 10, bottom: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    paint['price'].toString(),
                                    style: ShadTheme.of(context).textTheme.h2,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 1)),
                                  const Icon(
                                    LucideIcons.LucideIcons.euro,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                    size: 20,
                                  ),
                                ],
                              )),
                          Container(
                            padding: const EdgeInsets.only(
                                right: 20, top: 10, bottom: 0),
                            child: Text(
                              'Stock: ${paint['stock']}',
                              style: ShadTheme.of(context).textTheme.large,
                            ),
                          ),
                        ],
                      ),
                      Container(
                          width: double.infinity,
                          // height: double.infinity,
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                          ),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description',
                                style: ShadTheme.of(context).textTheme.h3,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
                                  style: ShadTheme.of(context).textTheme.p,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
              ],
            )),
      ),
    );
  }
}
