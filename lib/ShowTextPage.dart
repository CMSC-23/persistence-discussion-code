import 'package:flutter/material.dart';
import './DBHelper.dart';
import './Dog.dart';

class ShowTextpage extends StatefulWidget {
  ShowTextpage({Key? key}) : super(key: key);

  @override
  _ShowTextpageState createState() => _ShowTextpageState();
}

class _ShowTextpageState extends State<ShowTextpage> {
  
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
        title: Text("Dog List"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            myTextList(),
          ],
        ),
      ),
    );
  }

  
  Widget myTextList() {
    return Container(
      child: Expanded(
        child: FutureBuilder(
            future: myDog,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildText(snapshot.data as List <Dog>);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  //widget that returns listview of myDog data
  Widget buildText(List<Dog> myDog) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: myDog.length,
      itemBuilder: (context, int index) {
        return Center(
          child: ListTile(
            //put dog's name in the listtile widget
            title: Text(myDog[index].name),
          ),
        );
      },
    );
  }
}