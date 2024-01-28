import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
 List<XFile?>? images = []; // Store XFile objects directly
  final _picker = ImagePicker();
  bool showSpinner = false;


Future getImage() async {
    final List<XFile?>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null) {
      images = pickedImages; // Directly assign the list of XFile objects
      setState(() {});
    } else {
      print("No Image Selected");
    }
  }



 Future<void> uploadImage() async {
    if (images != null) {
      for (XFile? singleImage in images!) { // Iterate over XFile objects
        if (singleImage != null) {
          var request = http.MultipartRequest(
            'POST', Uri.parse('https://fakestoreapi.com/products'));
          request.fields['title'] = 'Static title';
          var multipart = await http.MultipartFile.fromPath(
            'image', singleImage.path); // Use imageFile.path
          request.files.add(multipart);

          var response = await request.send();
          print(request);

          if (response.statusCode == 200) {
              print("status code is");
            print(response.statusCode);
            print("Image Uploaded Successfully");
          
          } else {
            print("Upload failed for image: ${singleImage.path}");
          }
        }
      }
    } else {
      print("Please select an image first");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Imager")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                getImage();
              },
              child: Text('select image')),
          Container(
              child: images == null
                  ? Center(
                      child: Text('Pick Image'),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemCount: images!.length,
                      itemBuilder: (context, index) {
                         XFile? singleImage = images![index];
                        if (singleImage != null) {
                            return Image.file(File(singleImage.path),
                              height: 100, width: 100, fit: BoxFit.cover);
                        } else {
                          return Container();
                        }
                      },
                    )),
          SizedBox(
            height: 150,
          ),
          ElevatedButton(
            onPressed: () {
              uploadImage();

              print("Upload pressed");
            },
            child: Text("Upload"),
          )
        ],
      ),
    );
  }
}


