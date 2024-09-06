import 'package:flutter/material.dart';
import "nutrients.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "url.dart";

class automate_water extends StatefulWidget {
  automate_water({super.key, required this.title});

  final String title;

  @override
  State<automate_water> createState() => _automate_water_state();
}

class _automate_water_state extends State<automate_water> {
  // String soil = 'Soil Type';
  // var soilTypes = [
  //   'Soil Type',
  //   'Chalky',
  //   'Nitrogenous',
  //   'Sandy',
  //   'Clay',
  //   'Black Lava Soil',
  //   'Loamy',
  //   'Saline',
  //   'Alkaline'
  // ];

  String crop = 'Crop Type';
  var cropTypes = [
    'Crop Type',
    'Onion',
    'Pulses',
    'Citrus',
    'Cotton',
    'Bajra',
    'Tomato',
    'Fenugreek',
    'Chilli',
    'Gram',
    'Sugarcane',
    'Oilseeds',
    'Mustard',
    'Coriander',
    'Wheat',
    'Fennel',
    'Garlic',
    'Mango',
    'Opium',
    'Barley',
    'Guava',
    'Maize',
    'Cumin',
    'Pomegranate'
  ];

  sendData(var cr, var mois) async {
    if (cr == "Crop Type") {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('You have to pick soil and crop type.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    } else {
      try {
        var response = await http.post(Uri.parse(grabWaterData),
            body: {'crop': cr, 'water_availability': mois});
        var resBody = json.decode(json.encode(response.body));
        if (response.statusCode == 200) {
          print(resBody);
        } else {
          throw Exception(resBody);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  getData() async {
    try {
      var response =
          await http.post(Uri.parse(grabSensorData), body: {'user_id': userId});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        var valuesList = resBody.split(', ');
        var moisture = valuesList[0];
        print(valuesList);
        sendData(crop, moisture);
      } else {
        throw Exception('Failed to grab data.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  setOrder() async {
    try {
      var response = await http.post(Uri.parse(updateWaterOrder),
          body: {'user_id': userId, 'water_order': '2'});
      var resBody = json.decode(json.encode(response.body));
      if (response.statusCode == 200) {
        print(resBody);
        getData();
        return json.decode(json.encode(response.body));
      } else {
        throw Exception('Failed to update album.');
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
                      margin: const EdgeInsets.all(20),
                      child: const Text(
                        "Enter the required fields to automate",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      child: DropdownButton(
                        value: crop,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: cropTypes.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            crop = newValue!;
                          });
                        },
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
                            setOrder();
                          },
                          child: const Text("AUTOMATE",
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
              MaterialPageRoute(builder: (context) => nutrients(title: "")));
        },
        tooltip: 'Back',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
