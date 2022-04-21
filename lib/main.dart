import 'package:flutter/material.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropDownValue = 'One';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Location',
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Get Coordinates"),
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Get From Map"),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Name",
                        fillColor: Colors.blue[200]),
                    value: dropDownValue,
                    items: [],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
