import 'package:flutter/material.dart';
import 'car.dart';
import 'car_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Car> cars = [];

  Future<String?> populateCars(Function(bool success) update) async {
    try {
      final url = Uri.https("car-photo.000webhostapp.com", 'getCars.php');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      cars.clear();
      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body);
        for (var row in jsonResponse) {
          Car carr = Car(
            name: row['name'],
            imagePath: row['path'],
            quantity: int.parse(row['quantity']),
          );
          cars.add(carr);
        }
        update(true);
      }
    } catch (e) {
      update(false);
    }
  }

  void update(bool success){
    // TODO:
  }

  bool initialized = false;

  @override
  void initState() {
    populateCars(update).then((value) => setState(() => initialized = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !initialized ? const CircularProgressIndicator() : MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Car Categories'),
          centerTitle: true,
        ),
        body: CarList(cars: cars),
      ),
    );
  }
}
