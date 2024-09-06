import 'package:flutter/material.dart';
import "main.dart";
import 'package:http/http.dart' as http;
import "url.dart";
import "dart:convert";
import "home.dart";

class sign_in extends StatefulWidget {
  sign_in({super.key, required this.title});

  final String title;

  @override
  State<sign_in> createState() => _sign_in_state();
}

class _sign_in_state extends State<sign_in> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  validateEmail() async {
    try {
      var res = await http.post(Uri.parse(valEmail), body: {
        'email': email.text,
      });

      if (res.statusCode == 200) {
        final resBody = json.decode(json.encode(res.body));
        if (resBody == '"emailFound"') {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('ValidationError'),
                    content: const Text('Email is already in use'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        } else {
          sendData();
          var resp = await http.post(Uri.parse(logIn), body: {
            'email': email.text,
            'password': password.text,
          });
          final resBody = json.decode(json.encode(resp.body));
          userId = resBody;
          if (resBody == 'error') {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('ValidationError'),
                      content:
                          const Text('There is no account with this E-mail'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ));
          } else {
            userId = resBody;
            print(userId);
            var res = await http
                .post(Uri.parse(insertDevice), body: {'user_id': userId});
            final response = json.decode(json.encode(res.body));
            var resOrder = await http
                .post(Uri.parse(insertDeviceOrder), body: {'user_id': userId});
            final responseOrder = json.decode(json.encode(resOrder.body));
            print(response);
            print(responseOrder);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return home(title: "");
            })); // print(response);
          }
        }
      } else {
        print("xxxx");
      }
    } catch (e) {
      print(e.toString());
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('ValidationError'),
                content: Text(e.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
  }

  sendData() async {
    try {
      final res = await http.post(Uri.parse(signUp), body: {
        'email': email.text,
        'password': password.text,
      });
      var resBody = json.decode(json.encode(res.body));
      print(resBody);
    } catch (e) {
      print(e.toString());
    }
  }

  void validate(TextEditingController email, TextEditingController password) {
    if (email.text.isEmpty || password.text.isEmpty) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('ValidationError'),
                content: const Text('Some fields are empty'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    } else {
      validateEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF97D69C),
      backgroundColor: const Color(0xFF53C25C),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("images/other.jpg"),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text(
                "Welcome",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                width: 200,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero)),
                  ),
                  controller: email,
                  // onChanged: (String? newValue) {

                  // },
                )),
            Container(
                width: 200,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero)),
                  ),
                  controller: password,
                  // onChanged: (String? newValue) {

                  // },
                )),
            Container(
                width: 200,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: const BeveledRectangleBorder()),
                  onPressed: () {
                    validate(email, password);
                  },
                  child: const Text("SIGN IN",
                      style: TextStyle(color: Colors.white)),
                )),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have account?"),
                  TextButton(
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(46, 59, 98, 1)),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MyHomePage(title: "")));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
