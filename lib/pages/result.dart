import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:mscanner/styles/style.dart';

class UserData {
  final String name;
  final String semester;
  final String sCode;
  final String department;
  final String email; // Changed 'Email' to 'email'
  final String year; // Changed 'Year' to 'year'

  UserData({
    required this.name,
    required this.semester,
    required this.sCode,
    required this.department,
    required this.email, // Changed 'Email' to 'email'
    required this.year, // Changed 'Year' to 'year'
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['Name'],
      semester: json['Semester'],
      sCode: json['SCode'],
      department: json['Department'],
      email: json['Email'], // Changed 'Email' to 'email'
      year: json['Year'], // Changed 'Year' to 'year'
    );
  }
}

Future<UserData?> loadJson(String barcode) async {
  final logger = Logger();
  String jsonString = await rootBundle.loadString('assets/data/database.json');
  List<dynamic> jsonData = jsonDecode(jsonString);

  for (var item in jsonData) {
    if (item['SCode'] == barcode) {
      UserData data = UserData.fromJson(item);
      logger.i('Name: ${data.name}');
      logger.i('Semester: ${data.semester}');
      logger.i('SCode: ${data.sCode}');
      logger.i('Department: ${data.department}');
      return data;
    }
  }

  return null;
}

class ResultPage extends StatefulWidget {
  final String barcode;

  const ResultPage({Key? key, required this.barcode}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xFFFFAAAA),
      body: FutureBuilder<UserData?>(
        future: loadJson(widget.barcode),
        builder: (BuildContext context, AsyncSnapshot<UserData?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(
                child: Text(
              'Error Fetching \n\t\t\tTry again',
              style: customStyle(24),
            ));
          } else {
            return Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFCCCCC),
                border: Border.all(color: const Color(0xFFEB6161), width: 5.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: OrientationBuilder(builder: (context, orientation) {
                return orientation == Orientation.portrait
                    ? Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.65,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAAAAA),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    snapshot.data!.name,
                                    style: customStyle(32),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!
                                                  .email, // Changed 'Email' to 'email'
                                              style: customStyle(24),
                                            ),
                                            Text(
                                              '${snapshot.data!.semester} ${snapshot.data!.department}',
                                              style: customStyle(24),
                                            ),
                                            Text(
                                              snapshot.data!
                                                  .year, // Changed 'Year' to 'year'
                                              style: customStyle(24),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(),
                                        Image.asset(
                                          'assets/icons/pencil.png',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Boxy(
                                    // Changed 'boxy' to 'Boxy'
                                    imagePath: 'assets/icons/tick.png',
                                    flag: true,
                                    userData: snapshot.data!,
                                  ),
                                ),
                                Expanded(
                                  child: Boxy(
                                    // Changed 'boxy' to 'Boxy'
                                    imagePath: 'assets/icons/deny.png',
                                    flag: false,
                                    userData: snapshot.data!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.65,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAAAAA),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    snapshot.data!.name,
                                    style: customStyle(32),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!
                                                  .email, // Changed 'Email' to 'email'
                                              style: customStyle(24),
                                            ),
                                            Text(
                                              '${snapshot.data!.semester} ${snapshot.data!.department}',
                                              style: customStyle(24),
                                            ),
                                            Text(
                                              snapshot.data!
                                                  .year, // Changed 'Year' to 'year'
                                              style: customStyle(24),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(),
                                        Image.asset(
                                          'assets/icons/pencil.png',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Boxy(
                                    // Changed 'boxy' to 'Boxy'
                                    imagePath: 'assets/icons/tick.png',
                                    flag: true,
                                    userData: snapshot.data!,
                                  ),
                                ),
                                Expanded(
                                  child: Boxy(
                                    // Changed 'boxy' to 'Boxy'
                                    imagePath: 'assets/icons/deny.png',
                                    flag: false,
                                    userData: snapshot.data!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
              }),
            );
          }
        },
      ),
    );
  }
}

class Boxy extends StatefulWidget {
  final String imagePath;
  final bool flag;
  final UserData userData; // Pass only the data you need

  Boxy(
      {Key? key,
      required this.imagePath,
      required this.flag,
      required this.userData})
      : super(key: key);

  @override
  State<Boxy> createState() => _BoxyState();
}

class _BoxyState extends State<Boxy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: const Color(0xFFFAAAAA),
        border: Border.all(color: const Color(0xFFEB6161), width: 5.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextButton(
        onPressed: widget.flag ? savehive : deletehive,
        child: Image.asset(
          widget.imagePath,
          width: 300,
          height: 100,
        ),
      ),
    );
  }

  final _mydocs = Hive.box('attendees');

  savehive() {
    var attendees = Attendees(
      name: widget.userData.name, // Use the data directly
      semester: widget.userData.semester,
      scode: widget.userData.sCode,
      department: widget.userData.department,
      email: widget.userData.email,
      year: widget.userData.year,
      time: DateTime.now().toString(),
    );

    var allData = _mydocs.values;
    for (var data in allData) {
      print('attendees: $data');
    }
    _mydocs.add(attendees.toMap());
  }

  deletehive() {}
}

class Attendees {
  final String name;
  final String semester;
  final String scode;
  final String department;
  final String email;
  final String year;
  final String time;

  Attendees({
    required this.name,
    required this.semester,
    required this.scode,
    required this.department,
    required this.email,
    required this.year,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'semester': semester,
      'scode': scode,
      'department': department,
      'email': email,
      'year': year,
      'time': time,
    };
  }

  factory Attendees.fromMap(Map<String, dynamic> map) {
    return Attendees(
      name: map['name'],
      semester: map['semester'],
      scode: map['scode'],
      department: map['department'],
      email: map['email'],
      year: map['year'],
      time: map['time'],
    );
  }
}
