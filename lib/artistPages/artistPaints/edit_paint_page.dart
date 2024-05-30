import 'dart:io';

import 'package:comsart/http/paints.dart';
import 'package:comsart/routes/router.dart';
import 'package:comsart/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_lucide/flutter_lucide.dart' as LucideIcons;
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EditPaintPage extends StatefulWidget {
  final String id;

  const EditPaintPage({super.key, required this.id});

  @override
  State<EditPaintPage> createState() => _EditPaintPageState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class _EditPaintPageState extends State<EditPaintPage> {
  var paint = {};
  var _isLoading = true;
  var error = '';

  List<XFile> _imageFileList = [];
  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  final commission = TextEditingController();
  final format = TextEditingController();

  final formatPaints = [
    'Digital',
    'Physical',
  ];

  final typeCommission = [
    'Custom',
    'Pre-made',
  ];

  final formKey = GlobalKey<ShadFormState>();

  @override
  void initState() {
    super.initState();
    _getPaint();

    setState(() {
      _isLoading = false;
    });
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
    List<XFile> _downloadImages = [];

    final imagesPaint = getPaint['data']['paint']['images'];
    print(imagesPaint);

    for (var image in imagesPaint) {
      final imageUri = '${dotenv.env['API_URL']}/$image';
      final imageFile = await http.get(Uri.parse(imageUri));
      final imageBytes = imageFile.bodyBytes;

      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;

      final file = File('$tempPath/$image');
      if (!(await file.parent.exists())) {
        await file.parent.create(recursive: true);
      }
      await file.writeAsBytes(imageBytes);

      _downloadImages.add(XFile(file.path));
    }

    setState(() {
      paint = getPaint['data']['paint'];
      title.text = paint['title'];
      description.text = paint['description'];
      price.text = paint['price'].toString();
      stock.text = paint['stock'].toString();
      commission.text = paint['type_commission'].toString().capitalize();
      format.text = paint['format'].toString().capitalize();

      _imageFileList = _downloadImages;
    });
  }

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
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (paint.isEmpty || _isLoading == true)
                  Container(
                    alignment: Alignment.center,
                    child: LoadingAnimationWidget.inkDrop(
                      color: const Color(0xFFe74c3c),
                      size: 50,
                    ),
                  ),
                if (paint.isNotEmpty)
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: ShadButton(
                          onPressed: () {
                            showShadDialog(
                              context: context,
                              builder: (context) => ShadDialog.alert(
                                constraints: const BoxConstraints(
                                  maxWidth: 380,
                                ),
                                radius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                  color: Color.fromARGB(255, 123, 123, 123),
                                  width: 1,
                                ),
                                title: const Text(
                                  'Are you absolutely sure?',
                                  textAlign: TextAlign.left,
                                ),
                                description: const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    'This action cannot be undone. This will permanently delete your paint.',
                                  ),
                                ),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ShadButton(
                                      text: const Text('Yes, delete'),
                                      backgroundColor: const Color(0xFFdd4c4f),
                                      onPressed: () async {
                                        var req = await Paints()
                                            .deletePaint(widget.id);

                                        if (req['ok'] == false) {
                                          setState(() {
                                            error = req['data'];
                                          });
                                          return;
                                        }

                                        routerConfig.go(
                                          '/home/artist',
                                        );
                                      },
                                    ),
                                    ShadButton.outline(
                                      text: const Text('No, keep it'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                  ],
                                ),
                                actions: [],
                              ),
                            );
                          },
                          backgroundColor: Color(0xFFdd4c4f),
                          icon: const Icon(
                            LucideIcons.LucideIcons.trash,
                            size: 16,
                          ),
                          size: ShadButtonSize.icon,
                        ),
                      ),
                      if (error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      ),
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
                                              final image = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery);

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
                                                LucideIcons.LucideIcons.trash,
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
                          for (int i = 0; i < 4 - _imageFileList.length; i++)
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
                              keyboardType: TextInputType.number,
                              suffix: const Icon(
                                LucideIcons.LucideIcons.euro,
                                color: Colors.black,
                                size: 15,
                              ),
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

                                if (int.parse(v) % 1 != 0) {
                                  return 'Stock must be a whole number';
                                }

                                return null;
                              },
                            ),
                            ShadSelectFormField<String>(
                              minWidth: double.infinity,
                              label: const Text('Commission'),
                              initialValue: commission.text,
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
                              initialValue: format.text,
                              placeholder: const Text('Select a format'),
                              options: formatPaints
                                  .map((format) => ShadOption(
                                      value: format, child: Text(format)))
                                  .toList(),
                              selectedOptionBuilder: (context, value) =>
                                  value == 'none'
                                      ? const Text('Select a commission')
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
                                if (formKey.currentState!.validate()) {
                                  var req = await Paints().updatePaint(
                                      _imageFileList,
                                      widget.id,
                                      title.text,
                                      description.text,
                                      price.text,
                                      stock.text,
                                      commission.text,
                                      format.text);

                                  if (req['ok'] == false) {
                                    setState(() {
                                      error = req['data'];
                                    });
                                    return;
                                  }

                                  routerConfig.go(
                                    '/home/artist',
                                  );
                                }
                              },
                              text: const Text('Update paint'),
                              hoverBackgroundColor: const Color(0xFFe74c3c),
                              backgroundColor: const Color(0xFFdd4c4f),
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ));
  }
}
