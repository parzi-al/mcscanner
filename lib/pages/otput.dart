import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:mscanner/styles/style.dart';

class Listing extends StatefulWidget {
  const Listing({Key? key}) : super(key: key);

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xFFFFAAAA),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAAAAA),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.75,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAAAAA),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: const Color(0xFFEB6161),
                      width: 4.44,
                    ),
                  ),
                ),
              ),
              const Expanded(child: Detailo()),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCCCC),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB6161),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/circle-slash.png',
                              height: 20,
                              width: 20,
                            ),
                            const Text("  stop",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB6161),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/file-sliders.png',
                              height: 20,
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Detailo extends StatefulWidget {
  const Detailo({Key? key}) : super(key: key);

  @override
  State<Detailo> createState() => _DetailoState();
}

class _DetailoState extends State<Detailo> {
  late Box _mydocs;
  late Iterable allData;
  String? time;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    try {
      _mydocs = Hive.box('attendees');
      if (_mydocs.isEmpty) {
        logger.i('The box is empty');
      } else {
        allData = _mydocs.values;
        for (var data in allData) {
          logger.i('Event: $data');
        }
        var attendees = allData.first;
        time = attendees['time'];
        time = time!.substring(11, 16);
      }
    } catch (e) {
      logger.e('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: allData.length,
      itemBuilder: (context, index) {
        var attendees = allData.elementAt(index);
        return Container(
          margin: const EdgeInsets.all(10.00),
          decoration: BoxDecoration(
            color: const Color(0xFFFCCCCC),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${attendees['name']}', style: customStyle(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${attendees['semester']}  ${attendees['department']}',
                        style: customStyle(15)),
                    if (time != null)
                      Text(
                        time!,
                        style: customStyle(15),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
