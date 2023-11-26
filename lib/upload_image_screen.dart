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
  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future getImage() async {
    final pickFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickFile != null) {
      image = File(pickFile.path);
      setState(() {});
    } else {
      print("No Image Selected");
    }
  }

Future<void> uploadImage() async {
  showSpinner = true;
  if (mounted) {
    setState(() {});
  }

  if (image != null) {
    var request = http.MultipartRequest('POST', Uri.parse('https://fakestoreapi.com/products'));
    request.fields['title'] = 'Static title';
    var multipart = await http.MultipartFile.fromPath('image', image!.path);
    request.files.add(multipart);
    var response = await request.send();

    if (response.statusCode == 200) {
      showSpinner = false;
      if (mounted) {
        setState(() {});
      }
      print("Image Uploaded");
    } else {
      print("Upload failed");
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
          // TextButton(onPressed: () {
          //   _pickImageFromGallary();
          // }, child: Text("Pick Image from gallary")),
          // TextButton(onPressed: () {}, child: Text("Pick Image from camera")),
          // SizedBox(height: 20),
          // _selectedImage!=null? Image.file(_selectedImage!): Text("Select an image")

          GestureDetector(
            onTap: (){
              getImage();
              
            },
            child: Container(
                child: image == null
                    ? Center(
                        child: Text('Pick Image'),
                      )
                    : Container(
                        child: Center(
                          child: Image.file(
                            File(image!.path).absolute,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
          ),
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
  // Future _pickImageFromGallary() async{
  //  final pickedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
  //  if(pickedImage==null)return;
  //  Text(pickedImage.name);
  //  setState(() {
  //    _selectedImage=File(pickedImage.name);
  //  });

  // }
}
