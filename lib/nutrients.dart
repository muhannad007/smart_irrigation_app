import 'package:flutter/material.dart';
import "home.dart";
import "automate_nutrients.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "url.dart";
// import "main.dart";

class nutrients extends StatefulWidget {
  nutrients({super.key, required this.title});

  final String title;

  @override
  State<nutrients> createState() => _nutrients_state();
}

var nitro = 0;
var phos = 0;
var potas = 0;

class _nutrients_state extends State<nutrients> {
  turnPumpOn() async {
    try {
      var response = await http.post(Uri.parse(updateNutrientsOrder),
          body: {'user_id': '$userId', 'nutrients_order': '1'});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        print(resBody);
        return json.decode(json.encode(response.body));
      } else {
        throw Exception('Failed to update album.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  turnPumpOff() async {
    try {
      var response = await http.post(Uri.parse(updateNutrientsOrder),
          body: {'user_id': userId, 'nutrients_order': '0'});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        print(resBody);
        return json.decode(json.encode(response.body));
      } else {
        throw Exception('Failed to update album.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  getNPKData() async {
    try {
      var response =
          await http.post(Uri.parse(grabSensorData), body: {'user_id': userId});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        var valuesList = resBody.split(', ');
        setState(() {
          nitro = int.parse(valuesList[4]);
          phos = int.parse(valuesList[5]);
          potas = int.parse(valuesList[6]);
        });
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
      body: Container(
        child: Column(
          children: [
            Container(
              child: Image.asset("images/other.jpg"),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      margin: const EdgeInsets.all(20),
                    ),
                    Container(
                        width: 200,
                        height: 50,
                        // margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: const BeveledRectangleBorder()),
                          onPressed: () {
                            getNPKData();
                          },
                          child: const Text("CHECK NUTRIENTS",
                              style: TextStyle(color: Colors.white)),
                        )),
                    Container(
                      width: 200,
                      alignment: Alignment.center,
                      // margin: const EdgeInsets.fromLTRB(20, 5, 0, 10),
                      child: Text(
                          "N: $nitro [mg/kg]\n P: $phos [mg/kg]\n K: $potas [mg/kg]",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black)),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text(
                        "Nutrients Pump Control",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                        width: 200,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: const BeveledRectangleBorder()),
                          onPressed: () {
                            turnPumpOn();
                          },
                          child: const Text("ON",
                              style: TextStyle(color: Colors.white)),
                        )),
                    Container(
                        width: 200,
                        height: 50,
                        // margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: const BeveledRectangleBorder()),
                          onPressed: () {
                            turnPumpOff();
                          },
                          child: const Text("OFF",
                              style: TextStyle(color: Colors.white)),
                        )),
                    Container(
                        width: 200,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: const BeveledRectangleBorder()),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        automate_nutrients(title: "")));
                          },
                          child: const Text("AUTOMATIC",
                              style: TextStyle(color: Colors.white)),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => home(title: "")));
        },
        tooltip: 'Back',
        child: const Icon(Icons.arrow_back),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
