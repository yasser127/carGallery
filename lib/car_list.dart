import 'package:flutter/material.dart';
import 'car.dart';
import 'car_details.dart';

class CarList extends StatelessWidget {
  final List<Car> cars;

  CarList({required this.cars});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(cars[index].name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetails(car: cars[index]),
              ),
            );
          },
        );
      },
    );
  }
}
