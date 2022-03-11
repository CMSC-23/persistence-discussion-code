import 'package:flutter/material.dart';
//import necessary packages
import 'dog_model.dart';
import 'db_helper.dart';

class ShowDogsPage extends StatefulWidget {
  const ShowDogsPage({Key? key}) : super(key: key);

  @override
  _ShowDogsPageState createState() => _ShowDogsPageState();
}

class _ShowDogsPageState extends State<ShowDogsPage> {
  
  //create a DBHelper object to access database functions
  DBHelper db = DBHelper();

  //create a future list of dog that will store all the dog data from database
  late Future<List<Dog>> myDog;  

  @override
  void initState() {
    super.initState();
    
    //initialize myDog list by getting data from database
    myDog = db.dogs();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dog List"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          myDogList(),
        ],
      ),
    );
  }

  
  Widget myDogList() {
    return Expanded(

      //NOTE: Read more about FutureBuilder here: https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html
      child: FutureBuilder(
          future: myDog,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildText(snapshot.data as List <Dog>);
            } else {
              return const Center (child: CircularProgressIndicator( value: null, strokeWidth: 7.0));
            }
          }),
    );
  }

  //widget that returns listview of myDog data
  Widget buildText(List<Dog> myDog) {

    //NOTE: read more about ListView here: https://api.flutter.dev/flutter/material/ListTile-class.html
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: myDog.length,
      itemBuilder: (context, int index) {
        return Center(
          child: ListTile(
            //put dog's name in the ListTile widget
            title: Text(myDog[index].name),
          ),
        );
      },
    );
  }
}
