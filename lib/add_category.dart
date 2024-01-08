import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'car_app.dart';

const String _baseURL = 'car-photo.000webhostapp.com';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerID = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  bool _loading = false;
  bool _submissionSuccessful = false;

  @override
  void dispose() {
    _controllerID.dispose();
    _controllerName.dispose();
    super.dispose();
  }

  void update(bool success) {
    setState(() {
      if(success) {
        _submissionSuccessful = true;
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connection error!")));
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App bar details...
      ),
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(children:<Widget> [
            const SizedBox(height: 10),
            SizedBox(width: 200, child: TextFormField(controller: _controllerID,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter ID',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter id';
                }
                return null;
              },
            )),
            const SizedBox(height: 10),
            SizedBox(width: 200, child: TextFormField(controller: _controllerName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _loading = true;
                  });
                  saveInformation(
                        (success) {
                      update(success);
                    },
                    int.parse(_controllerID.text.toString()),
                    _controllerName.text.toString(),
                  );
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _loading,
              child: const CircularProgressIndicator(),
            ),
            const SizedBox(height: 10),
            _submissionSuccessful
                ? ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              child: const Text('Next'),
            )
                : Container(),
          ],
          ),
        ),
      ),
    );
  }
}

void saveInformation(Function(bool) update, int id, String name) async {
  try {
    // send a JSON object using http post
    final url = Uri.https(_baseURL, "save.php");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'id': '$id',
        'name': name,
      }),
    ).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      // if successful, call the update function
      final jsonResponse = convert.jsonDecode(response.body);
      final found = jsonResponse['success'];
      update(found);
    }
    else {
      update(false);
    }
  }
  catch(e) {
    update(false);
  }
}