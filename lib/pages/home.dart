import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mscanner/pages/navigator.dart';
import 'package:mscanner/styles/style.dart';

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);
  final _mydocs = Hive.box('events');
  @override
  Widget build(BuildContext context) {
    var allData = _mydocs.values;

    return Scaffold(
      backgroundColor: const Color(0xFFFFAAAA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            SizedBox(
              width: 184, // diameter
              height: 184, // diameter
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavigatorPage()),
                  );
                },
                shape: const CircleBorder(),
                backgroundColor: const Color(0xFFFF9090),
                elevation: 2,
                child: Image.asset(
                  'assets/icons/circle-fading-plus.png',
                ),
              ),
            ),
            SizedBox(
              width: 190,
              height: 50,
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  'assets/icons/Arrow.png',
                ),
              ),
            ),
            allData.isNotEmpty
                ? const Eventdata()
                : Text(
                    'Start a new Event  !!',
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color(0xFFFFDFDF),
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class Eventdata extends StatefulWidget {
  const Eventdata({super.key});

  @override
  State<Eventdata> createState() => _EventdataState();
}

class _EventdataState extends State<Eventdata> {
  final _mydocs = Hive.box('events');

  @override
  Widget build(BuildContext context) {
    var allData = _mydocs.values;
    return Expanded(
      child: ListView.builder(
          itemCount: allData.length,
          itemBuilder: (context, index) {
            var events = allData.elementAt(index);
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
                    Text('${events['name']}', style: customStyle(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${events['description']}  ${events['organisation']}',
                            style: customStyle(15)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
