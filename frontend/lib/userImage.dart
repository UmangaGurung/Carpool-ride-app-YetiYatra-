import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yeti_yatra_project/login.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'HistoryScreen/GlobalUrl.dart';

class ImagePage extends StatefulWidget {
  final Map<String, dynamic> data;

  const ImagePage({super.key, required this.data});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  void _showPhotoRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Photo Required'),
          content: Text('Please select a photo before proceeding.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    final String url = Global.url;

    if (_image == null) {
      // Handle the case where no image is selected
      _showPhotoRequiredDialog(context);
      return;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$url/register'));
      request.headers.addAll({'Content-Type': 'multipart/form-data'});

      // Add the form data
      widget.data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      var response = await request.send();

      if (response.statusCode == 201) {
        Get.to(
          () => Login(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 500),
        );
        print('Data sent successfully');
      } else {
        throw Exception('Failed to send data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error sending data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.12),
        child: AppBar(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          leading: IconButton(
            padding: EdgeInsets.only(
                top: screenHeight * 0.035, left: screenWidth * 0.05),
            icon: const Icon(
              Icons.arrow_circle_left_rounded,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.035),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.',
                    style: TextStyle(fontFamily: 'Futura'))
                : Image.file(File(_image!.path)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getImage,
              child: const Text(
                'Take a Photo',
                style: TextStyle(fontSize: 18, fontFamily: 'Futura', color: Color.fromRGBO(34, 207, 249, 1),),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 18,fontFamily: 'Futura'),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(34, 207, 249, 1),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
