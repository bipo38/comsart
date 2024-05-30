import 'dart:io';

import 'package:comsart/Widgets/NavbarArtist.dart';
import 'package:comsart/http/paints.dart';
import 'package:comsart/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart' as LucideIcons;
import 'package:image_picker/image_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/effects/shimmer_effect.dart' as ShimmerEffect;

// ignore: must_be_immutable
class CreatePaintPage extends StatefulWidget {
  CreatePaintPage({super.key});

  @override
  State<CreatePaintPage> createState() => _CreatePaintPageState();
}

class _CreatePaintPageState extends State<CreatePaintPage> {
  final List<XFile>? _imageFileList = [];

  final formatPaints = [
    'Digital',
    'Physical',
  ];

  final typeCommission = [
    'Custom',
    'Pre-made',
  ];

  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  final commission = TextEditingController();
  final format = TextEditingController();

  final formKey = GlobalKey<ShadFormState>();

  var erroMessageForm = false;

  final imageLimit = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xFFf8fafc),
            leading: IconButton(
              icon: const Icon(LucideIcons.LucideIcons.arrow_left),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        bottomNavigationBar: const NavbarArtist(index: 1),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(10),
            child: Skeletonizer(
              enabled: false,
              effect: const ShimmerEffect.ShimmerEffect(
                duration: Duration(seconds: 4),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_imageFileList != null)
                      Column(
                        children: [
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.5,
                            shrinkWrap: true,
                            children: [
                              for (int i = 0; i < _imageFileList.length; i++)
                                InkWell(
                                  onTap: () => showShadSheet(
                                    context: context,
                                    side: ShadSheetSide.bottom,
                                    builder: (context) => ShadSheet(
                                      constraints: const BoxConstraints(
                                          maxWidth: 512, maxHeight: 200),
                                      description:
                                          const Text("What do you want to do?"),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ShadButton(
                                                width: 100,
                                                icon: const Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    LucideIcons
                                                        .LucideIcons.pen_line,
                                                    size: 16,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final image =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);

                                                  if (image == null) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    _imageFileList[i] = image;
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                text: const Text('Edit'),
                                                hoverBackgroundColor:
                                                    const Color(0xFFe74c3c),
                                                backgroundColor:
                                                    const Color(0xFFdd4c4f),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.all(10)),
                                              ShadButton.outline(
                                                onPressed: () {
                                                  setState(() {
                                                    _imageFileList.removeAt(i);
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                icon: const Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Icon(
                                                    LucideIcons
                                                        .LucideIcons.trash,
                                                    size: 16,
                                                  ),
                                                ),
                                                text: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(_imageFileList[i].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              for (int i = 0;
                                  i < 4 - _imageFileList.length;
                                  i++)
                                InkWell(
                                  onTap: () async {
                                    final image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    if (image == null) {
                                      return;
                                    }

                                    setState(() {
                                      _imageFileList.add(image);
                                    });
                                  },
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                        ),
                                      )),
                                ),
                            ],
                          ),
                        ],
                      ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    if (erroMessageForm)
                      const Text(
                        'Minimum 1 image is required.',
                        style: TextStyle(color: Colors.red),
                      ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    ShadForm(
                        key: formKey,
                        child: Column(
                          children: [
                            ShadInputFormField(
                              controller: title,
                              label: const Text('Title'),
                              keyboardType: TextInputType.text,
                              maxLength: 50,
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'Title is required';
                                }

                                if (v.length > 50) {
                                  return 'Max length is 50 characters';
                                }

                                return null;
                              },
                            ),
                            ShadInputFormField(
                              controller: description,
                              label: const Text('Description'),
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              maxLength: 500,
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'Description is required';
                                }

                                if (v.length > 500) {
                                  return 'Max length is 500 characters';
                                }

                                return null;
                              },
                            ),
                            ShadInputFormField(
                              controller: price,
                              label: const Text('Price'),
                              suffix: const Icon(
                                LucideIcons.LucideIcons.euro,
                                color: Colors.black,
                                size: 15,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'Price is required';
                                }

                                if (double.parse(v) < 0) {
                                  return 'Price must be greater than 0';
                                }

                                return null;
                              },
                            ),
                            ShadInputFormField(
                              controller: stock,
                              label: const Text('Stock'),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'Stock is required';
                                }
                                if (v.contains('.') ||
                                    v.contains(',') ||
                                    v.contains('-')) {
                                  return 'Stock must be an integer';
                                }

                                if (int.parse(v) < 0) {
                                  return 'Stock must be greater than 0';
                                }

                                return null;
                              },
                            ),
                            ShadSelectFormField<String>(
                              minWidth: double.infinity,
                              label: const Text('Commission'),
                              initialValue: null,
                              placeholder: const Text('Select a format'),
                              onChanged: (v) {
                                commission.text = v!;
                              },
                              options: typeCommission
                                  .map((commission) => ShadOption(
                                      value: commission,
                                      child: Text(commission)))
                                  .toList(),
                              selectedOptionBuilder: (context, value) =>
                                  value == 'none'
                                      ? const Text('Select a commission')
                                      : Text(value),
                              validator: (v) {
                                if (v == null) {
                                  return 'Type commission is required';
                                }

                                return null;
                              },
                            ),
                            ShadSelectFormField<String>(
                              label: const Text('Format'),
                              minWidth: double.infinity,
                              onChanged: (v) {
                                format.text = v!;
                              },
                              initialValue: null,
                              placeholder: const Text('Select a format'),
                              options: formatPaints
                                  .map((format) => ShadOption(
                                      value: format, child: Text(format)))
                                  .toList(),
                              selectedOptionBuilder: (context, value) =>
                                  value == 'none'
                                      ? const Text('Select a format')
                                      : Text(value),
                              validator: (v) {
                                if (v == null) {
                                  return 'Format is required';
                                }

                                return null;
                              },
                            ),
                            ShadButton(
                              onPressed: () async {
                                if (_imageFileList == null ||
                                    _imageFileList.isEmpty) {
                                  setState(() {
                                    erroMessageForm = true;
                                  });
                                  return;
                                }

                                if (formKey.currentState!.validate()) {
                                  var req = await Paints().createPaint(
                                      _imageFileList,
                                      title.text,
                                      description.text,
                                      price.text,
                                      stock.text,
                                      commission.text,
                                      format.text);

                                  if (req['ok'] == false) {
                                    setState(() {
                                      erroMessageForm = true;
                                    });
                                    return;
                                  }
                                  setState(() {
                                    erroMessageForm = false;
                                  });

                                  routerConfig.go(
                                    '/home/artist',
                                  );
                                }
                              },
                              text: const Text('Create Paint'),
                              hoverBackgroundColor: const Color(0xFFe74c3c),
                              backgroundColor: const Color(0xFFdd4c4f),
                              width: double.infinity,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )));
  }
}

// class ImageOptionsSheet extends StatefulWidget {
//   final ShadSheetSide side;
//   final int i;

//   const ImageOptionsSheet({super.key, required this.side, required this.i});

//   @override
//   State<ImageOptionsSheet> createState() => _ImageOptionsSheetState();
// }

// class _ImageOptionsSheetState extends State<ImageOptionsSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return ShadSheet(
//       constraints: widget.side == ShadSheetSide.left ||
//               widget.side == ShadSheetSide.right
//           ? const BoxConstraints(maxWidth: 512)
//           : null,
//       title: const Text('Edit Profile'),
//       description: const Text(""),
//       content: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ShadButton(
//               onPressed: () {
//                 setState(() {
//                   _imageFileList.removeAt(widget.i);
//                 });

//                 Navigator.pop(context);
//               },
//               text: const Text('Delete'),
//               hoverBackgroundColor: const Color(0xFFe74c3c),
//               backgroundColor: const Color(0xFFdd4c4f),
//             ),
//             ShadButton(
//               onPressed: () async {
//                 final image =
//                     await ImagePicker().pickImage(source: ImageSource.gallery);

//                 if (image == null) {
//                   return;
//                 }
//                 setState(() {
//                   _imageFileList[widget.i] = image;
//                 });

//                 Navigator.pop(context);
//               },
//               text: const Text('Edit'),
//               hoverBackgroundColor: const Color(0xFFe74c3c),
//               backgroundColor: const Color(0xFFdd4c4f),
//             ),
//           ],
//         ),
//       ),
//       actions: const [
//         ShadButton(text: Text('Save changes')),
//       ],
//     );
//   }
// }
