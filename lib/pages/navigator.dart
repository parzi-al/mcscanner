import 'package:flutter/material.dart';
import 'package:mscanner/pages/home.dart';
import 'package:mscanner/pages/newEvent.dart';
import 'package:mscanner/pages/otput.dart';
import 'package:mscanner/pages/scanner.dart';
import 'package:mscanner/pages/result.dart';

class NavigatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number List'),
      ),
      body: Container(
        color: Color(0xFFFFAAAA),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Number ${index + 1}'),
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewEvent()),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Scanbar()),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ResultPage(barcode: "21CS091")),
                  );
                } else if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Listing()),
                  );
                } else if (index == 5) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                } else if (index == 6) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
