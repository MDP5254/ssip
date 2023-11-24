import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

hii

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Map<String, dynamic> dict = {};
  Map<String, dynamic> dict1 = {};
  Map<String, dynamic> dict2 = {};
  Map<String, dynamic> dict3 = {};
  String profileURL = '';

  Map<String, dynamic> dict4 = {};
  Map<String, dynamic> dict5 = {};
  Map<String, dynamic> dict6 = {};
  Map<String, dynamic> dict7 = {};

  String profileURL1 = '';

  List<String> imageUrls = [];

  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.6:5200/number-frequency'));

      final response1 = await http
          .get(Uri.parse('http://192.168.1.6:5200/hashtag-frequency'));

      final response2 = await http
          .get(Uri.parse('http://192.168.1.6:5200/location-frequency'));

      final response3 =
          await http.get(Uri.parse('http://192.168.1.6:5200/profile-picture'));

      final response4 =
          await http.get(Uri.parse('http://192.168.1.6:5200/offensive-bio'));

      final response5 = await http
          .get(Uri.parse('http://192.168.1.6:5200/offensive-comments'));

      final response6 =
          await http.get(Uri.parse('http://192.168.1.6:5200/follower-count'));

      final response7 =
          await http.get(Uri.parse('http://192.168.1.6:5200/following-count'));
        
      final response8 = await http.get(Uri.parse('http://192.168.1.11:5000/images'));

      if (response.statusCode == 200) {
        setState(() {
          dict = json.decode(response.body);
          dict1 = json.decode(response1.body);
          dict2 = json.decode(response2.body);
          dict3 = json.decode(response3.body);
          dict4 = json.decode(response4.body);
          dict5 = json.decode(response5.body);
          dict6 = json.decode(response6.body);
          dict7 = json.decode(response7.body);

          profileURL = dict3['profile_path'];

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

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
  


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(211, 211, 211, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile Report',
          style: TextStyle(
            color: Colors.white, // Set the text color
            fontSize: 30, // Set the font size
            fontWeight: FontWeight.bold, // Set the font weight
          ),
        ),
        backgroundColor: const Color.fromRGBO(3, 30, 64, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            // Set the width to cover the entire screen
            height: 1500, // Set the desired height
            child: Column(children: [
              Row(
                children: [
                  Container(
                    color: Color.fromRGBO(211, 211, 211, 1),

                    width: 110, // Set your desired width
                    height: 110, // Set your desired height
                    child: ClipOval(
                        child: Image.asset(
                      'assets/images/dummy.jpg',
                      fit: BoxFit.cover,
                    )),
                  ),
                  Container(
                    width: 10,
                    color: Color.fromRGBO(211, 211, 211, 1),
                  ),
                  Container(
                    height: 110,
                    color: Color.fromRGBO(211, 211, 211, 1),

                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator() // Show loading indicator
                          : errorMessage.isNotEmpty
                              ? Text(errorMessage)
                              : Column(children: <Widget>[
                                  DataTable(
                                    columns: <DataColumn>[
                                      DataColumn(label: Text('Following ')),
                                    ],
                                    rows: dict6.entries
                                        .map(
                                          (entry) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                  Text(entry.value.toString())),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  )
                                ]),
                    ), // Your content for this section
                  ),
                  Container(
                    height: 110,
                    color: Color.fromRGBO(211, 211, 211, 1),

                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator() // Show loading indicator
                          : errorMessage.isNotEmpty
                              ? Text(errorMessage)
                              : Column(children: <Widget>[
                                  DataTable(
                                    columns: <DataColumn>[
                                      DataColumn(label: Text('Followers')),
                                    ],
                                    rows: dict7.entries
                                        .map(
                                          (entry) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                  Text(entry.value.toString())),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  )
                                ]),
                    ), // Your content for this section
                  ),
                ],
              ),
              Container(height: 20, color: Color.fromRGBO(211, 211, 211, 1)),
              Container(
                height: 200,
                color: Color.fromRGBO(211, 211, 211, 1),

                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator() // Show loading indicator
                      : errorMessage.isNotEmpty
                          ? Text(errorMessage)
                          : Column(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: Color.fromRGBO(96, 130, 182, 1),
                                child: Center(
                                  child: Text('Number Frequency',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              DataTable(
                                columns: <DataColumn>[
                                  DataColumn(label: Text('Number')),
                                  DataColumn(label: Text('Frequency')),
                                ],
                                rows: dict.entries
                                    .map(
                                      (entry) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(entry.key)),
                                          DataCell(
                                              Text(entry.value.toString())),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              )
                            ]),
                ), // Your content for this section
              ),
              Container(
                height: 200,
                color: Color.fromRGBO(211, 211, 211,
                    1), // Set the background color for this section
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator() // Show loading indicator
                      : errorMessage.isNotEmpty
                          ? Text(errorMessage)
                          : Column(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: Color.fromRGBO(96, 130, 182, 1),
                                child: Center(
                                  child: Text('Hastag Mentioned',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              DataTable(
                                columns: <DataColumn>[
                                  DataColumn(label: Text('Hashtags')),
                                  DataColumn(label: Text('Frequency')),
                                ],
                                rows: dict1.entries
                                    .map(
                                      (entry) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(entry.key)),
                                          DataCell(
                                              Text(entry.value.toString())),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              )
                            ]),
                ),
              ),
              Container(
                height: 200,
                color: Color.fromRGBO(211, 211, 211,
                    1), // Set the background color for this section
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator() // Show loading indicator
                      : errorMessage.isNotEmpty
                          ? Text(errorMessage)
                          : Column(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: Color.fromRGBO(96, 130, 182, 1),
                                child: Center(
                                  child: Text('Location Mentioned',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              DataTable(
                                columns: <DataColumn>[
                                  DataColumn(label: Text('Location')),
                                  DataColumn(label: Text('Frequency')),
                                ],
                                rows: dict2.entries
                                    .map(
                                      (entry) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(entry.key)),
                                          DataCell(
                                              Text(entry.value.toString())),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              )
                            ]),
                ), // Your content for this section
              ),
              Container(
                height: 200,
                color: Color.fromRGBO(211, 211, 211, 1),

                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator() // Show loading indicator
                      : errorMessage.isNotEmpty
                          ? Text(errorMessage)
                          : Column(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: Color.fromRGBO(96, 130, 182, 1),
                                child: Center(
                                  child: Text('Offensive Bio',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              DataTable(
                                columns: <DataColumn>[
                                  DataColumn(label: Text('Bio')),
                                ],
                                rows: dict4.entries
                                    .map(
                                      (entry) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                              Text(entry.value.toString())),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              )
                            ]),
                ), // Your content for this section
              ),
              Container(
                height: 200,
                color: Color.fromRGBO(211, 211, 211, 1),

                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator() // Show loading indicator
                      : errorMessage.isNotEmpty
                          ? Text(errorMessage)
                          : Column(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: Color.fromRGBO(96, 130, 182, 1),
                                child: Center(
                                  child: Text('Offensive Comment',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              DataTable(
                                columns: <DataColumn>[
                                  DataColumn(label: Text('Comment')),
                                ],
                                rows: dict5.entries
                                    .map(
                                      (entry) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                              Text(entry.value.toString())),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              )
                            ]),
                ), // Your content for this section
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
