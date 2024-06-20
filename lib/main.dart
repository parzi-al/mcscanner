import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mscanner/pages/navigator.dart';

void main() async {
  await Hive.initFlutter();
  var box1 = await Hive.openBox('events');
  var box2 = await Hive.openBox('attendees');
  box1.clear();
  box2.clear();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(surface: const Color(0xFFFFAAAA)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: NavigatorPage(),
    );
  }
}
