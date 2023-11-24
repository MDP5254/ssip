import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FastAPI Image List Example'),
        ),
        body: ApiImageList(),
      ),
    );
  }
}

class ApiImageList extends StatefulWidget {
  @override
  _ApiImageListState createState() => _ApiImageListState();
}

class _ApiImageListState extends State<ApiImageList> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    try {
      // Replace with the actual address of your FastAPI server
      final response = await http.get(Uri.parse('http://192.168.1.11:5000/images'));
      if (response.statusCode == 200) {
        final List<String> urls = List<String>.from(json.decode(response.body));
        setState(() {
          imageUrls = urls;
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
    return imageUrls.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(  itemCount: imageUrls.length,
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
          );
  }
}
