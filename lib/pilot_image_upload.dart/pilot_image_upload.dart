import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PilotImageUpload extends StatefulWidget {
  const PilotImageUpload({super.key});

  @override
  State<PilotImageUpload> createState() => _PilotImageUploadState();
}

class _PilotImageUploadState extends State<PilotImageUpload> {
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
      for (XFile? singleImage in images!) {
        // Iterate over XFile objects
        if (singleImage != null) {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://pilotbazar.com/api/merchants/vehicles/products/store'),
                
        
          );
          request.fields['title'] = jsonEncode({
            'En':'dfsf',
            'Bn':'dfsfs',
          });    
        request.fields['upload_preset'] = 'xzxyhatj';

         var multipart = await http.MultipartFile.fromPath(
              'image', singleImage.path); // Use imageFile.path
          request.files.add(multipart);
            var response = await request.send();

            if(response.statusCode==200){
              final responseData = await response.stream.toBytes();
              final responseString = String.fromCharCodes(responseData);
              final jsonMap = jsonDecode(responseString);
              setState(() {
                final url = jsonMap('url');
                
              }); 
            }
        


          // request.fields['title'] =
          //     '{"en": "Toyota Demo Car", "bn": "টয়টা ডেমো "}';
          // request.fields['user_id'] =
          //     2.toString(); // Convert the integer to a string
          // request.fields['category_id'] =
          //     1.toString(); // Convert the integer to a string
          // request.fields['merchant_id'] =
          //     1.toString(); // Convert the integer to a string
          // request.fields['brand_id'] =
          //     9.toString(); // Convert the integer to a string
          // request.fields['condition_id'] =
          //     5.toString(); // Convert the integer to a string
          // request.fields['transmission_id'] =
          //     4.toString(); // Convert the integer to a string
          // request.fields['engines'] =
          //     45643.toString(); // Convert the integer to a string
          // request.fields['edition_id'] =
          //     10.toString(); // Convert the integer to a string
          // request.fields['fuel_id'] =
          //     4.toString(); // Convert the integer to a string
          // request.fields['skeleton_id'] =
          //     7.toString(); // Convert the integer to a string
          // request.fields['mileages'] =
          //     9348.toString(); // Convert the integer to a string
          // request.fields['manufacture'] =
          //     2014.toString(); // Convert the integer to a string

          // request.fields['is_feat'] =
          //     1.toString(); // Convert the integer to a string
          // request.fields['status'] =
          //     1.toString(); // Convert the integer to a string
          // request.fields['is_approved'] =
          //     1.toString(); // Convert the integer to a string
          // request.fields['publish_at'] = "2012-1-2";
          // request.fields['code'] = "PS-098";
          // request.fields['available_id'] =
          //     4.toString(); // Convert the integer to a string
          // request.fields['registration_id'] =
          //     6.toString(); // Convert the integer to a string
          // request.fields['carmodel_id'] =
          //     6.toString(); // Convert the integer to a string
          // request.fields['color_id'] =
          //     3.toString(); // Convert the integer to a string
          // request.fields['fixed_price'] =
          //     943949.toString(); // Convert the integer to a string
          // request.fields['price'] =
          //     349349.toString(); // Convert the integer to a string
          // request.fields['chassis_number'] = "dk3499";
          // request.headers.addAll({
          //   'Accept': 'application/json',
          //   'Content-Type': 'application/json',
          // });

          // var multipart = await http.MultipartFile.fromPath(
          //     'image', singleImage.path); // Use imageFile.path
          // request.files.add(multipart);

         // var response = await request.send();
          setState(() {});
          print(request);
          print("status code is");
        //  print(response.statusCode);
          print("Image Name ${singleImage.path}");

          // if (response.statusCode == 200) {
          //   print("status code is");
          //   print(response.statusCode);
          //   print("Image Uploaded Successfully");
          // }
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
