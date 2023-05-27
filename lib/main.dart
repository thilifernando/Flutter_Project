//dependencies
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const FirstFlutterApp());
}

class FirstFlutterApp extends StatelessWidget {
  const FirstFlutterApp({Key? key}) : super(key: key);

  // The main widget of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thilani Fernando Flutter Task',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(title: 'HomePage'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nicController = TextEditingController();
  //initiating variables
  String error = '';
  String gender = '';
  String year = '';
  String month = '';
  String day = '';
  String dob = '';

  @override
  void dispose() {
    nicController.dispose();
    super.dispose();
  }

//method to clean the fields
  void _extractNICdata() {
    setState(() {
      error = '';
      gender = '';
      year = '';
      month = '';
      day = '';
      dob = '';
    });

    //retrievE the entered NIC number from the nicController
    // ignore: non_constant_identifier_names    
    String NICNum = nicController.text;
    int dayText = 0;

    if (NICNum.length != 10 && NICNum.length != 12) {
      setState(() {
        error = 'You have entered an invalid number';
      });
    } else if (NICNum.length == 10 && !_isNumeric(NICNum.substring(0, 9))) {
      setState(() {
        error = 'You have entered an invalid number';
      });
    } else {
      // Extracting NIC owner's birth year
      //For old NIC, add addition '19' for the first two digits of the NIC
      if (NICNum.length == 10) {
        // ignore: prefer_interpolation_to_compose_strings
        year = '19' + NICNum.substring(0, 2);
        //dayText assign after extracting NIC index 2 to 5 by string
        //int.prase convert it to integer
        dayText = int.parse(NICNum.substring(2, 5));
      } else {
        //For new NIC, first four digits express the birth year
        year = NICNum.substring(0, 4);
        //dayText assign after extracting NIC index 4 to 7 by string
        //int.prase convert it to integer
        dayText = int.parse(NICNum.substring(4, 7));
      }

      // Extracting NIC owner's gender
      if (dayText > 500) {
        gender = 'Female';
        dayText = dayText - 500;
      } else {
        gender = 'Male';
      }

      //Validating day
      if (dayText < 1 && dayText > 366) {
        setState(() {
          error = 'You have entered an invalid number';
        });
      } else {
        // Month
        if (dayText > 335) {
          day = (dayText - 335).toString();
          month = 'December';
        } else if (dayText > 305) {
          day = (dayText - 305).toString();
          month = 'November';
        } else if (dayText > 274) {
          day = (dayText - 274).toString();
          month = 'October';
        } else if (dayText > 244) {
          day = (dayText - 244).toString();
          month = 'September';
        } else if (dayText > 213) {
          day = (dayText - 213).toString();
          month = 'August';
        } else if (dayText > 182) {
          day = (dayText - 182).toString();
          month = 'July';
        } else if (dayText > 152) {
          day = (dayText - 152).toString();
          month = 'June';
        } else if (dayText > 121) {
          day = (dayText - 121).toString();
          month = 'May';
        } else if (dayText > 91) {
          day = (dayText - 91).toString();
          month = 'April';
        } else if (dayText > 60) {
          day = (dayText - 60).toString();
          month = 'March';
        } else if (dayText < 32) {
          month = 'January';
          day = dayText.toString();
        } else if (dayText > 31) {
          day = (dayText - 31).toString();
          month = 'February';
        }
//convertING month names into two-digit month numbers
// ignore: no_leading_underscores_for_local_identifiers
        String _getMonthNumber(String month) {
          switch (month) {
            case 'January':
              return '01';
            case 'February':
              return '02';
            case 'March':
              return '03';
            case 'April':
              return '04';
            case 'May':
              return '05';
            case 'June':
              return '06';
            case 'July':
              return '07';
            case 'August':
              return '08';
            case 'September':
              return '09';
            case 'October':
              return '10';
            case 'November':
              return '11';
            case 'December':
              return '12';
            default:
              return '';
          }
        }

        setState(() {
          // ignore: prefer_interpolation_to_compose_strings
          dob = DateTime.parse(year + '-' + _getMonthNumber(month) + '-' + day)
              .toString();
        });

        //Displaying NIC details in the UI
        setState(() {
          gender = gender;
          dob = dob;
        });
      }
    }
  }
// checking if a given string is numeric
  bool _isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Flutter Task - Page 01 - Sri Lankan NIC number converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nicController,
              decoration: const InputDecoration(
                labelText: 'Type NIC number here',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _extractNICdata,
              child: const Text('SUBMIT'),
            ),
            const SizedBox(height: 20.0),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
            Text('Gender : $gender'),
            Text('Date of Birth : $dob'),

            //page navigation button
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SecondPage(title: 'SecondPage');
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(
                        255, 77, 2, 57), // Set the color of the button
                    width: 1.0, // Set the border width
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Set the border radius
                ),
                padding: const EdgeInsets.all(5.0),
                child: const Text('Move to Second Page'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Implementation of the next page

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Map<String, dynamic>? album;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Task - Page 02 - HTTP GET Request'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('SEND'),
            ),
            const SizedBox(height: 20.0),
            //Text(OutPutOfTheHTTP),
            if (album != null)
              Column(
                children: [
                  Text(
                    'Title: ${album!['title']}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'ID: ${album!['id']}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    'User_ID: ${album!['userId']}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),

            //page navigation button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(
                        255, 77, 2, 57), // Set the color of the button
                    width: 1.0, // Set the border width
                  ),
                  borderRadius:
                      BorderRadius.circular(8.0), // Set the border radius
                ),
                padding: const EdgeInsets.all(5.0),
                child: const Text('Back to First Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/albums/3');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        album = jsonData;
      });
    } else {
      setState(() {
        album = null;
      });
    }
  }
}
