import 'package:flutter/material.dart';
import "package:irrigation/automate_water.dart";
import "home.dart";
import "url.dart";
import "dart:convert";
import "package:http/http.dart" as http;
// import "main.dart";

class soilMoisture extends StatefulWidget {
  soilMoisture({super.key, required this.title});

  final String title;

  @override
  State<soilMoisture> createState() => _soilMoisture_state();
}

var moist = 0;

class _soilMoisture_state extends State<soilMoisture> {
  turnPumpOn() async {
    try {
      var response = await http.post(Uri.parse(updateWaterOrder),
          body: {'user_id': userId, 'water_order': '1'});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        print(resBody);
        return json.decode(json.encode(response.body));
      } else {
        throw Exception('Failed to update order.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  turnPumpOff() async {
    try {
      var response = await http.post(Uri.parse(updateWaterOrder),
          body: {'user_id': userId, 'water_order': '0'});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        print(resBody);
        return json.decode(json.encode(response.body));
      } else {
        throw Exception('Failed to update order.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  getWaterData() async {
    try {
      var response =
          await http.post(Uri.parse(grabSensorData), body: {'user_id': userId});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        var valuesList = resBody.split(', ');
        setState(() {
          moist = int.parse(valuesList[1]);
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
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
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
                            getWaterData();
                          },
                          child: const Text("CHECK soilMoisture",
                              style: TextStyle(color: Colors.white)),
                        )),
                    Container(
                      width: 200,
                      alignment: Alignment.center,
                      // margin: const EdgeInsets.fromLTRB(20, 5, 0, 10),
                      child: Text("$moist %",
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
                        "soilMoisture Pump Control",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                        width: 200,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                        // margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: const BeveledRectangleBorder()),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        automate_water(title: "")));
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
