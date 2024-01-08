import 'package:flutter/material.dart';
import 'car.dart';
import 'car_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as conv;
import 'car_app.dart';

class CarList extends StatefulWidget {
  final List<Car> cars;

  CarList({required this.cars});

  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  void updateQuantity(Function(bool success) update, int index) async {
    try{
      final url = Uri.https("car-photo.000webhostapp.com", "decrementQuantity.php");
      final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: conv.jsonEncode(<String, String>{
            'name': widget.cars[index].name
          })).timeout(const Duration(seconds: 5));

      if(response.statusCode == 200){
        // final temp = response.body;
        update(true);
      }
    }catch(e){
      update(false);
    }
  }
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: widget.cars.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.cars[index].name),
              Text(
                'Quantity: ${widget.cars[index].quantity.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () {
              // Decrease quantity by one when the button is pressed
              if (widget.cars[index].quantity > 0) {
                // Ensure quantity is greater than 0
                // You may want to handle this condition based on your application logic
                setState(() {
                  widget.cars[index].quantity--;
                updateQuantity((success) => null, index);
                });
              }
            },
            child: Text('Buy'),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetails(car: widget.cars[index]),
              ),
            );
          },
        );
      },
    );
  }
}
