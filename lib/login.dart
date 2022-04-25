import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mangoes/modals/usermodal.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var isloading = false;
    var assetsImage = const AssetImage('assets/images/logo.png');
    var image = Image(image: assetsImage, height: 300);
    final mobilecontroller = TextEditingController();
    final passwordcontroller = TextEditingController();

    void toggleSubmitState() {
      setState(() {
        isloading = !isloading;
        print(isloading);
      });
    }

    Future<void> login() async {
      var headers = {'Content-Type': 'text/plain'};
      var request = http.Request('POST',
          Uri.parse('http://mangoes.thefruitcastle.com/check_user.php'));
      request.body = '''{\n  "mobile": "''' +
          mobilecontroller.text +
          '''",\n  "password": "''' +
          passwordcontroller.text +
          '''"\n}''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());

        final usermodal =
            usermodalFromJson(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            image,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: mobilecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Login',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            ElevatedButton(onPressed: login, child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
