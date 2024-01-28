import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MultiPleImage extends StatefulWidget {
  const MultiPleImage({super.key});

  @override
  _MultiPleImageState createState() => _MultiPleImageState();
}

class _MultiPleImageState extends State<MultiPleImage> {
  // Use List of XFile to store selected images
  List<XFile?> selectedImages = [];
  var resJson;
  Future<void> getImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    setState(() {
      selectedImages = pickedImages;
    });
  }

  Future<void> onUploadImages() async {
    Map<String, String> formData = {
      'title[en]': 'English Title',
      'title[bn]': 'Bangla Title',
      'user_id': '2',
      'category_id': '1',
      'merchant_id': '1',
      'condition_id': '9',

      'transmission_id': '5',
      'engines': '4',

      'edition_id': '1',
      'fuel_id': '10',
      'skeleton_id': '4',

      'mileages': '7',
      'manufacture': '2012',

      'is_feat': '1', // Convert the integer to a string

      'status': '1',

      'is_approved': '1', // Convert the integer to a string
      'publish_at': '2001-2-2', // Convert the integer to a string

      'code': '8',
      'available_id': '4',
      'registration_id': '6', // Convert the integer to a string
      'carmodel_id': '6',
      'fixed_price': '1000', // Convert the integer to a string
      'price': '1212',

      'chassis_number': 'dk3499',

      'brand_id': '1',
      'color_id': '7',
     
    };

    Map<String, String> headers = {
      'Accept': 'application/vnd.api+json',
      'Content-Type': 'application/vnd.api+json',
      'Authorization':
          'Bearer 172|xhR0Oq2QDOqA1AhbEkW8H5x7eppLPJQVtbI0hc86a6d10273'
    };
    if (selectedImages.isNotEmpty) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            "https://pilotbazar.com/api/merchants/vehicles/products/store",
          ),
           // Replace with your actual API URL
        );
        request.headers.addAll(headers);
      

        // Loop through each selected image
        for (XFile? imageFile in selectedImages) {
          if (imageFile != null) {
            final fileLength = await imageFile.length();

            request.files.add(
              http.MultipartFile(
                'image', // Adjust key based on your API
                await imageFile.readAsBytes().asStream(),
                fileLength,
                filename: imageFile.name, // Use XFile's name property
              ),
            );
          }
        }
        request.fields.addAll(formData);
        // request.fields['title[en]'] = 'English Title';
        // request.fields['title[bn]'] = 'Demo mehedi';
        // request.fields['user_id'] = '2';

        // request.fields['category_id'] =
        //     1.toString(); // Convert the integer to a string
        // request.fields['merchant_id'] =
        //     1.toString(); // Convert the integer to a string
        // request.fields['condition_id'] =
        //     9.toString(); // Convert the integer to a string
        // request.fields['transmission_id'] =
        //     5.toString(); // Convert the integer to a string
        // request.fields['engines'] =
        //     4.toString(); // Convert the integer to a string
        // request.fields['edition_id'] =
        //     1.toString(); // Convert the integer to a string
        // request.fields['fuel_id'] =
        //     10.toString(); // Convert the integer to a string
        // request.fields['skeleton_id'] =
        //     4.toString(); // Convert the integer to a string
        // request.fields['mileages'] =
        //     7.toString(); // Convert the integer to a string
        // request.fields['manufacture'] =
        //     9348.toString(); // Convert the integer to a string
        // request.fields['is_feat'] =
        //     1.toString(); // Convert the integer to a string

        // request.fields['status'] =
        //     1.toString(); // Convert the integer to a string
        // request.fields['is_approved'] =
        //     1.toString(); // Convert the integer to a string
        // request.fields['publish_at'] =
        //     1.toString(); // Convert the integer to a string

        // request.fields['code'] = "6";
        // request.fields['available_id'] =
        //     4.toString(); // Convert the integer to a string
        // request.fields['registration_id'] =
        //     6.toString(); // Convert the integer to a string
        // request.fields['carmodel_id'] =
        //     6.toString(); // Convert the integer to a string
        // request.fields['fixed_price'] =
        //     3.toString(); // Convert the integer to a string
        // request.fields['price'] =
        //     943949.toString(); // Convert the integer to a string
        // // Convert the integer to a string
        // request.fields['chassis_number'] = "dk3499";

        // request.fields['brand_id'] = "1";
        // request.fields['color_id'] = "7";
        // request.fields['publish_at'] = "2002-2-2";

        var response = await request.send();
        // Map decodedResponse = jsonDecode(response.body);
        final responseData = await response.stream.bytesToString();
        print(responseData);
      } catch (error) {
        print(error);
        // Handle error gracefully (e.g., display an error message)
      }
    }
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
            // Display picked images (grid view might be suitable)
            if (selectedImages.isNotEmpty)
              SingleChildScrollView(
                primary: false,
                child: Row(
                  children: selectedImages
                      .map((imageFile) => Image.file(
                            File(imageFile!.path),
                            height: 100,
                            width: 100,
                          ))
                      .toList(),
                ),
              )
            else
              Text(
                'Please Pick Images to Upload',
              ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: onUploadImages,
              child: Text(
                "Upload",
                style: TextStyle(color: Colors.green),
              ),
            ),
            Text(resJson != null ? resJson['message'] : ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImages,
        tooltip: 'Pick Images',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}


// request.fields['title'] = jsonEncode({
//   'bn': 'fdfd',
//   'en': 'ds',
// })