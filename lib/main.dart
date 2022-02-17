import 'package:flutter/material.dart';
import 'DBHelper.dart';
import 'Dog.dart';
import 'ShowTextPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

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
  final TextEditingController _controller = TextEditingController(); //controller for getting name
  final TextEditingController _controller2 = TextEditingController(); //controller for getting age
  final _formKey = GlobalKey<FormState>();

  //create a DBHelper object to access database functions
  DBHelper db = DBHelper();

  //counter variable for Dog id
  int counter = 0;

  bool _validate = false; //used for validation of input

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
            buildTextField('Enter name', _controller),
            buildTextField('Enter age', _controller2),
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
          border: OutlineInputBorder(),
          labelText: label,
          errorText: _validate ? 'Value can\'t be empty' : null),
      validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (_controller == _controller2){
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
              Dog dog1 = Dog(id: counter++, name: _controller.text,age :int.parse(_controller2.text));

              //insert dog object to database
              db.insertDog(dog1);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
            //clear text on controllers after successful insert of data to database
            _controller.clear();
            _controller2.clear();
          }
        });
  }

  Widget buildViewButton() {
    return ElevatedButton(
      onPressed: () {
        //navigates to ShowTextpage that contains list of database content 
        Navigator.push(
             context, MaterialPageRoute(builder: (context) => ShowTextpage()));
      },
      child: const Text("View"),
    );
  }

  //function to validate if string is a number
  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }
}
