import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:last/models/profile_model.dart';

import '../api_connection/api_connection.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({Key? key}) : super(key: key);

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _twitterController = TextEditingController();
  final _statusController = TextEditingController();
  File? _image;

  final _picker = ImagePicker();

  String? base64Image;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        final bytes = File(pickedFile.path).readAsBytesSync();
        base64Image = base64Encode(bytes);
      } else {
        print('No image selected.');
      }
    });
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_image != null) ...[
                  SizedBox(
                    height: 200,
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text('Select Image'),
                ),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                  ),
                  validator: _validateField,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                  validator: _validateField,
                ),
                TextFormField(
                  controller: _instagramController,
                  decoration: const InputDecoration(
                    labelText: 'Instagram',
                  ),
                ),
                TextFormField(
                  controller: _facebookController,
                  decoration: const InputDecoration(
                    labelText: 'Facebook',
                  ),
                ),
                TextFormField(
                  controller: _twitterController,
                  decoration: const InputDecoration(
                    labelText: 'Twitter',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final profile = await createProfile({
                          'bio': _bioController.text,
                          'city': _cityController.text,
                          'instagram': _instagramController.text,
                          'facebook': _facebookController.text,
                          'twitter': _twitterController.text,
                          // 'status': _statusController.text,
                          'profile_pic':
                              base64Image, // добавляем base64 строку в тело запроса
                        });
                        Navigator.pop(context, profile);
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: const Text('Create Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
