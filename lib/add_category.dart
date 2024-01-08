import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'car_app.dart';

const String _baseURL = 'https://amrosite.000webhostapp.com';
EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerID = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  bool _loading = false;
  bool _submissionSuccessful = false;

  @override
  void dispose() {
    _controllerID.dispose();
    _controllerName.dispose();
    super.dispose();
  }

  void update(String text, {bool successful = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
      _submissionSuccessful = successful;
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
                  saveCategory(
                        (text) {
                      update(text, successful: true);
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

void saveCategory(Function(String text) update, int cid, String name) async {
  try {
    // we need to first retrieve and decrypt the key
    String myKey = await _encryptedData.getString('myKey');
    // send a JSON object using http post
    final response = await http.post(
        Uri.parse('$_baseURL/rabia/save.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, // convert the cid, name and key to a JSON object
        body: convert.jsonEncode(<String, String>{
          'cid': '$cid', 'name': name, 'key': myKey
        })).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      // if successful, call the update function
      update(response.body);
    }
  }
  catch(e) {
    update("connection error");
  }
}

class AnotherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Another Screen'),
      ),
      body: const Center(
        child: Text('This is another screen.'),
      ),
    );
  }
}