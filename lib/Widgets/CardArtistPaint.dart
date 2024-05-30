import 'package:comsart/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_lucide/flutter_lucide.dart' as LucideIcons;
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardArtistPaint extends StatelessWidget {
  Map<String, dynamic> paint = {};

  CardArtistPaint({
    super.key,
    required this.paint,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routerConfig.go('/home/artist/paints/${paint['id']}');
      },
      child: Skeleton.leaf(
        child: ShadCard(
          padding: const EdgeInsets.all(0),
          content: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
                child: Image.network(
                  '${dotenv.env['API_URL']}/${paint['images'][0]}',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        paint['title'],
                        overflow: TextOverflow.ellipsis,
                        style: ShadTheme.of(context).textTheme.list,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    textDirection: TextDirection.rtl,
                    LucideIcons.LucideIcons.chevron_right,
                    color: Colors.black,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
