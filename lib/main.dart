import 'package:flutter/material.dart';
import "sign_in.dart";
import "home.dart";
import "package:http/http.dart" as http;
import "url.dart";
import "dart:convert";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // TextEditingController email = TextEditingController();

  validateUser() async {
    var res = await http.post(Uri.parse(logIn), body: {
      'email': email.text,
      'password': password.text,
    });
    final resBody = json.decode(json.encode(res.body));
    if (resBody == 'error') {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('ValidationError'),
                content: const Text('There is no account with this E-mail'),
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
      // print(response);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return home(title: "");
      }));
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
      validateUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF53C25C),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("images/splash.jpg"),
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
                  style: TextStyle(color: Colors.black),
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
                  child: const Text("LOG IN",
                      style: TextStyle(color: Colors.white)),
                )),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Don't have account?"),
                  TextButton(
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(46, 59, 98, 1)),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => sign_in(title: "")));
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
