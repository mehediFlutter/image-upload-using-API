
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SingleImageFromNate(),
    );
  }
}



class SingleImageFromNate extends StatefulWidget {
  const SingleImageFromNate({super.key});

  @override
  _SingleImageFromNateState createState() => _SingleImageFromNateState();
}

class _SingleImageFromNateState extends State<SingleImageFromNate> {
  XFile? selectedImage; // Use XFile for image handling
  var resJson;

  Future<void> onUploadImage() async {
    if (selectedImage != null) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse("Enter Your API Url"), // Replace with your actual API URL
        );

        final fileLength = await selectedImage!.length();

        Map<String, String> headers = {"Content-Type": "multipart/form-data"};
        request.files.add(
          http.MultipartFile(
            'image',
            await selectedImage!.readAsBytes().asStream(),
            fileLength,
            filename: selectedImage!.name, // Use XFile's name property
          ),
        );
        request.headers.addAll(headers);

        var response = await request.send();
        final responseData = await response.stream.bytesToString();
        resJson = jsonDecode(responseData);

        setState(() {}); // Update UI based on response
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> getImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImage == null
                ? Text(
                    'Please Pick an Image to Upload',
                  )
                : Image.file(File(selectedImage!.path)),
            ElevatedButton(
              onPressed: onUploadImage,
              child: Text(
                "Upload",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(resJson != null ? resJson['message'] : ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
