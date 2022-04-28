import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mangoes/login.dart';
import 'package:mangoes/modals/Mangovariant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // variables

  var nameController = new TextEditingController();
  var numberController = new TextEditingController();

  var addressController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  var indexValue;
  dynamic assetsImage;
  // Initial Selected Value
  String dropdownvalue = "Select Fruit Variant";
  var listMango;
  var listMangoId;
  var latitude;
  var longitude;
  var base64string;

  var prefs;

  // List of items in our dropdown menu
  List<String> items = ["Select Fruit Variant"];

  /*onCreate*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mangoDbInsert(); //method

    getprefs();

    print("hi");
  }

  Future<void> getprefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> mangoDbInsert() async {
    var request = http.Request(
        'POST', Uri.parse('http://mangoes.thefruitcastle.com/mango_read.php'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      final mangovariant =
          mangovariantFromJson(await response.stream.bytesToString());
      for (var i = 0; i < mangovariant.body.length; i++) {
        listMango = (mangovariant.body[i].mangoName);
        listMangoId = (mangovariant.body[i].id);
        items.add(listMango);
      }

      print(listMango + listMangoId);

      // print(items);
    } else {
      print(response.reasonPhrase);
    }
  }

  // end variables
  @override
  Widget build(BuildContext context) {
    // functions

    //function1

    Future<void> getImagefromcamera() async {
      XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      // String base64Image = base64Encode(photo);
      File imagefile = File(photo!.path); //convert Path to File
      Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
      base64string = base64.encode(imagebytes); //convert bytes to base64 string
      print(base64string);
      setState(() {
        assetsImage = Image.file(File(photo.path));
      });
    }
// function 1 end

// Function 2
    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    }

//funtion 2 end

// function 3 start
    Future<void> sendData() async {
      // print(
      //     "${nameController.text} ///// ${numberController.text}/// ${indexValue.toString()}/// ${latitude.toString()}///${longitude.toString()}////${base64string}////${addressController.text}12233");
      var headers = {'Content-Type': 'text/plain'};
      var request = http.Request(
          'POST', Uri.parse('http://mangoes.thefruitcastle.com/create.php'));
      request.body = '''       {\n            "name": "''' +
          nameController.text +
          '''",\n            "mobile": "''' +
          numberController.text +
          '''",\n            "mango_variant": "''' +
          indexValue.toString() +
          '''",\n            "latitude": "''' +
          latitude.toString() +
          '''",\n            "longtitude": "''' +
          longitude.toString() +
          '''",\n            "img": "''' +
          base64string +
          '''",\n            "address": "''' +
          addressController.text +
          '''",\n            "created_by": "''' +
          prefs.getString("id") +
          '''",\n            "updated_by": "''' +
          prefs.getString("id") +
          '''"\n        }''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }
// function 3 ends

// function insert mango db

    return Scaffold(
      appBar: AppBar(
        title: Text("Fruit Castle"),
        actions: [
          GestureDetector(
            onTap: () async {
              prefs.remove("name");
              prefs.remove("id");
              prefs.remove("mobile");

              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()));
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: longitude == null
                      ? Text("Please click Get coordinates button")
                      : Text(longitude.toString() + "  " + latitude.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var currentLocation = await _determinePosition();
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      // print(position.toString());

                      setState(() {
                        latitude = position.latitude;
                        longitude = position.longitude;
                      });
                    },
                    child: Text("Get Coordinates"),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: numberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: addressController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  filled: true,
                ),
                // Initial Value
                value: dropdownvalue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  // mangoDbInsert();
                  setState(() {
                    dropdownvalue = newValue!;
                    indexValue = items.indexOf(newValue);
                    print(indexValue);
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 120.0,
                    width: 120.0,
                    child: assetsImage == null ? Container() : assetsImage,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () {
                      setState(() {
                        assetsImage = null;
                      });
                    },
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ElevatedButton(
                      onPressed: () {
                        getImagefromcamera();
                      },
                      child: Text("Take Photo")),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    print(items);
                    sendData();
                  },
                  child: Text("Submit")),
            ),
          ],
        ),
      ),
    );
  }
}
