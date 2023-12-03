import 'package:flutter/material.dart';
import 'car.dart';
import 'car_list.dart';

class MyApp extends StatelessWidget {
  final List<Car> cars = [
    Car(name: 'Sedan', imagePath: 'assets/sedan1.jpg'),
    Car(name: 'SUV', imagePath: 'assets/suv1.jpg'),
    Car(name: 'Truck', imagePath: 'assets/truck1.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Car Categories'),
        ),
        body: CarList(cars: cars),
      ),
    );
  }
}