import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mscanner/pages/navigator.dart';
import 'package:mscanner/styles/style.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class Event {
  final String name;
  final String description;
  final String organisation;

  Event(
      {required this.name,
      required this.description,
      required this.organisation});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'organisation': organisation,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'],
      description: map['description'],
      organisation: map['organisation'],
    );
  }
}

class _NewEventState extends State<NewEvent> {
  String? dropdownValue;
  final eventNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _mydocs = Hive.box('events');
  void writedata() {
    if (_formKey.currentState!.validate()) {
      var event = Event(
        name: eventNameController.text,
        description: descriptionController.text,
        organisation: dropdownValue!,
      );
      storeEvent(event);
      var allData = _mydocs.values;
      for (var data in allData) {
        log('Event: $data');
      }
    }
  }

  void storeEvent(Event event) {
    _mydocs.add(event.toMap());
  }

  @override
  void dispose() {
    eventNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFAAAA),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomFloatingActionButton(
                  onPressed: writedata,
                  eventNameController: eventNameController,
                  descriptionController: descriptionController,
                  dropdownValue: dropdownValue,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildContent(),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50),
                  CustomFloatingActionButton(
                    onPressed: writedata,
                    eventNameController: eventNameController,
                    descriptionController: descriptionController,
                    dropdownValue: dropdownValue,
                  ),
                  _buildContent(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 50),
        child: Container(
          width: 350,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCCCC),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: eventNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an event name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFFFAAAA),
                      filled: true,
                      labelText: "Event Name",
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFAAAA),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          isExpanded: true,
                          dropdownColor: const Color(0xFFFFAAAA),
                          icon: const Icon(Icons.arrow_downward),
                          iconEnabledColor: Colors.black,
                          hint: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Choose Organisation",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          items: <String>['IEEE', 'GDSC', 'and more...']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Descriptor(
                    descriptionController: descriptionController,
                    formKey: _formKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton(
      {super.key,
      required this.onPressed,
      required this.eventNameController,
      required this.descriptionController,
      required this.dropdownValue});

  final VoidCallback onPressed;
  final TextEditingController eventNameController;
  final TextEditingController descriptionController;
  final String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 184,
      height: 184,
      child: FloatingActionButton(
        onPressed: () {
          if (eventNameController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty &&
              dropdownValue != null &&
              dropdownValue!.isNotEmpty) {
            onPressed();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavigatorPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please fill all the fields before proceeding.',
                  style: customStyle(16),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: const Color(0xFFFF9090),
                behavior: SnackBarBehavior
                    .floating, // Set the background color to red
              ),
            );
          }
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFFFF9090),
        elevation: 2,
        child: Image.asset(
          'assets/icons/Frame.png',
        ),
      ),
    );
  }
}

class Descriptor extends StatefulWidget {
  const Descriptor(
      {Key? key, required this.descriptionController, required this.formKey})
      : super(key: key);

  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;

  @override
  State<Descriptor> createState() => _DescriptorState();
}

class _DescriptorState extends State<Descriptor> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Description",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: widget.descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              maxLines: 8,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                fillColor: const Color(0xFFFFAAAA),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
