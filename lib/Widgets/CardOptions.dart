import 'package:comsart/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardOption extends StatelessWidget {
  final String title;
  final String imageRoute;
  final String route;

  const CardOption({
    required this.title,
    required this.imageRoute,
    required this.route,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routerConfig.go(route);
      },
      child: Skeleton.leaf(
        child: ShadCard(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(10),
          // backgroundColor:  Color(0xfffdd79b),
          columnMainAxisAlignment: MainAxisAlignment.center,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          content: Center(
            child: Column(
              children: [
                 ShadImage(
                   imageRoute,
                  width: 130,
                  height: 130,
                ),
                Text(
                  title,
                  style: ShadTheme.of(context).textTheme.list,
                )
              ],
            ),
          ),
        ),
      ),
    );
   
  }
}
