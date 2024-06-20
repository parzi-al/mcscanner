import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logger/logger.dart';
import 'package:mscanner/pages/result.dart';

class Scanbar extends StatefulWidget {
  Scanbar({Key? key}) : super(key: key);

  @override
  State<Scanbar> createState() => _ScanbarState();
}

class _ScanbarState extends State<Scanbar> {
  String barcode = "";
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xFFFFAAAA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 184, // diameter
                height: 184, // diameter
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFFFF9090),
                  elevation: 2,
                  onPressed: scan,
                  child: Image.asset('assets/icons/Frame.png'),
                ),
              ),
              Text(
                  barcode == null || barcode.isEmpty
                      ? 'Start Scanning'
                      : barcode,
                  style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCCCC),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            barcode = "";
                          });
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
                            const Text("  Clear",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {}
                        //  scanImageFromGallery
                        ,
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

  Future scan() async {
    try {
      ScanResult result = await BarcodeScanner.scan();
      setState(() {
        barcode = result.rawContent ??
            ""; // assign an empty string if rawContent is null
        logger.i(barcode); // print barcode information in the console
      });
      if (barcode.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultPage(barcode: barcode)),
        );
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => barcode = 'Unknown error: $e');
      }
    } catch (e) {
      setState(() => barcode = 'Unknown error: $e');
    }
  }
}
