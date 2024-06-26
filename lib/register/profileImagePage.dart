import 'dart:io';

import 'package:comsart/register/registerStore.dart';
import 'package:comsart/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePage extends StatefulWidget {
  const ProfileImagePage({super.key});

  @override
  State<ProfileImagePage> createState() => _ProfileImagePageState();
}

class _ProfileImagePageState extends State<ProfileImagePage> {
  File? _image;

  var isImage = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          isImage = false;
        });
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf8fafc),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShadForm(
                child: Column(children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(children: [
                  if (_image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (_image == null)
                    const ShadImage(
                      'assets/img/profile.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      alignment: Alignment.topLeft,
                    ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ShadButton.outline(
                    onPressed: _pickImage,
                    text: const Text('Pick Image from Gallery'),
                    decoration: const ShadDecoration(
                      border: ShadBorder(
                        color: Color.fromARGB(62, 152, 151, 151),
                        width: 1,
                      ),
                    ),
                    width: double.infinity,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        LucideIcons.image,
                        size: 14,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  ShadButton(
                    onPressed: () {
                      if (_image == null) {
                        setState(() {
                          isImage = true;
                        });
                        return;
                      }

                      setState(() {
                        isImage = false;
                      });

                      RegisterStore().setProfileImage(_image!);

                      routerConfig.go(
                          '/register/email/registerOption/name/profileImage/password');
                    },
                    text: const Text('Continue'),
                    hoverBackgroundColor: const Color(0xFFe74c3c),
                    backgroundColor: const Color(0xFFdd4c4f),
                    width: double.infinity,
                  ),
                ]),
              ),
              if (isImage)
                const Text(
                  'Please select an image',
                  style: TextStyle(color: Colors.red),
                ),
            ]))
          ],
        ),
      ),
    );
  }
}
