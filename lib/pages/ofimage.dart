import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class ApiImageList extends StatefulWidget {
  @override
  _ApiImageListState createState() => _ApiImageListState();
}

class _ApiImageListState extends State<ApiImageList> {
  List<String> imageUrls = [];
  List<String> imageUrls1 = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    try {
      // Replace with the actual address of your FastAPI server
      final response = await http.get(Uri.parse('http://192.168.0.109:5200/image-text-paths'));
      final response1 = await http.get(Uri.parse('http://192.168.0.109:5200/image-gun-paths'));

      if (response.statusCode == 200) {
        final List<String> urls = List<String>.from(json.decode(response.body));
        final List<String> urls1 = List<String>.from(json.decode(response1.body));
        setState(() {
          imageUrls = urls+urls1;

        });
      } else {
        print('Failed to fetch image URLs: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching image URLs: $error');
    }
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Offensive Images',
          style: TextStyle(
            color: Colors.white, // Set the text color
            fontSize: 30, // Set the font size
            fontWeight: FontWeight.bold, // Set the font weight
          ),
        ),
        backgroundColor: const Color.fromRGBO(3, 30, 64, 1),
        centerTitle: true,
      ),
      body:
      imageUrls.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        imageUrls[index],
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              
    ); 
           
      
  
  }
}
