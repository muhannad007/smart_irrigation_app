import 'package:flutter/material.dart';
import "nutrients.dart";
import "soilMoisture.dart";
import "main.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "url.dart";
// import "main.dart";

class home extends StatefulWidget {
  home({super.key, required this.title});

  final String title;

  @override
  State<home> createState() => _home_state();
}

var temp = 0;
var humid = 0;

class _home_state extends State<home> {
  getData(int num) async {
    try {
      var response =
          await http.post(Uri.parse(grabSensorData), body: {'user_id': userId});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        var valuesList = resBody.split(', ');
        if (num == 1) {
          setState(() {
            humid = int.parse(valuesList[3]);
          });
        }
        if (num == 2) {
          setState(() {
            temp = int.parse(valuesList[2]);
          });
        }
        print(humid);
      } else {
        throw Exception('Failed to grab data.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF97D69C),
      body: SizedBox(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          child: Image.asset("images/other.jpg"),
        ),
        Container(
          width: 200,
          margin: const EdgeInsets.all(20),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 200,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: const BeveledRectangleBorder()),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => soilMoisture(title: "")));
                      },
                      child: const Text("SOIL MOISTURE",
                          style: TextStyle(color: Colors.white)),
                    )),
                Container(
                    width: 200,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: const BeveledRectangleBorder()),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => nutrients(title: "")));
                      },
                      child: const Text("NUTRIENTS",
                          style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(
                    width: 200,
                    height: 50,
                    // margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: const BeveledRectangleBorder()),
                      onPressed: () {
                        getData(1);
                      },
                      child: const Text("HUMIDITY",
                          style: TextStyle(color: Colors.white)),
                    )),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Text("$humid %",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Container(
                    width: 200,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: const BeveledRectangleBorder()),
                      onPressed: () {
                        getData(2);
                      },
                      child: const Text("TEMPERATURE",
                          style: TextStyle(color: Colors.white)),
                    )),
                Container(
                  width: 200,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(20, 5, 0, 10),
                  child: Text("$temp \u2103",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
              ],
            ),
          ),
        )
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyHomePage(title: "")));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
