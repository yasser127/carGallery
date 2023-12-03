import 'package:flutter/material.dart';
import 'car.dart';

class CarDetails extends StatelessWidget {
  final Car car;

  CarDetails({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              car.imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              car.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RefillCalculator(),
                  ),
                );
              },
              child: Text('Calculate Tank Refill Cost'),
            ),
          ],
        ),
      ),
    );
  }
}

// Create a new screen for the tank refill calculator
class RefillCalculator extends StatefulWidget {
  @override
  _RefillCalculatorState createState() => _RefillCalculatorState();
}

class _RefillCalculatorState extends State<RefillCalculator> {
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  double totalCost = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tank Refill Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Gas Price'),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Number of Tanks'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double price = double.parse(priceController.text);
                int quantity = int.parse(quantityController.text);
                setState(() {
                  totalCost = price * quantity;
                });
              },
              child: Text('Calculate Total Cost'),
            ),
            SizedBox(height: 20),
            Text(
              'Total Cost: \$${totalCost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}