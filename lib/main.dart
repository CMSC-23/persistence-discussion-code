import 'package:flutter/material.dart';
//import necessary packages
import 'db_helper.dart';
import 'dog_model.dart';
import 'show_dogs_page.dart';

void main() {
  //move here the ensureInitialized method of WidgetsFlutterBinding from the db_helper.dart
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Persistence';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: const MyStatefulWidget(title: 'Dogs Database'),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final TextEditingController _name = TextEditingController(); //controller for getting name
  final TextEditingController _age = TextEditingController(); //controller for getting age
  final _formKey = GlobalKey<FormState>();

  //create a DBHelper object to access database functions
  DBHelper db = DBHelper();

  //create a counter variable for Dog id
  int counter = 0;

  final bool _validate = false; //used for validation of input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildTextField('Enter name', _name),
            buildTextField('Enter age', _age),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSaveButton(),
                buildViewButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  //function for creating a textfield widget which accepts the label and controller as parameter
  Widget buildTextField(String label, TextEditingController _controller) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          errorText: _validate ? 'Value can\'t be empty' : null),
      validator: (value) {

        //validates if value in controller/textfield is not empty
          if (value == null || value.isEmpty) {
            return 'Please $label';
          }

          //validates if the controller/textfield is for age
          if (_controller == _age){

            //checks if input is integer
            if (! _isNumeric(value)){
              return 'Input integer only';
            }
          }
          return null;
        },
    );
  }

  //function for creating save button
  Widget buildSaveButton() {
    return ElevatedButton(
        child: const Text('Save'),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
              
              //instantiate a dog object 
              Dog dog1 = Dog(id: counter++, name: _name.text, age:int.parse(_age.text));

              //insert dog object to database
              db.insertDog(dog1);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
            //clear text on controllers after successful insert of data to database
            _name.clear();
            _age.clear();
          }
        });
  }

  Widget buildViewButton() {
    return ElevatedButton(
      onPressed: () {
        //navigate to ShowDogsPage that contains list of dogs from the database 
        Navigator.push(
             context, MaterialPageRoute(builder: (context) => const ShowDogsPage()));

      },
      child: const Text("View"),
    );
  }

  //function to validate if string is a number
  bool _isNumeric(String result) {
    return double.tryParse(result) != null;
  }
}
