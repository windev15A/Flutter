import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 25, 10, 5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Menu principal", style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
              SizedBox(height: 15,),
              ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/maps'),
                  icon: Icon(Icons.map),
                  label: Text("Google maps")),
              ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  icon: Icon(Icons.payment_rounded),
                  label: Text("CRUD (Create,Read,Update,Delete) ")),
              ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/sqlLite'),
                  icon: Icon(Icons.data_saver_off),
                  label: Text("SqlLite + flutter")),
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.laptop_chromebook),
                  label: Text("Google maps")),
            ],
          ),
        ),
      ),
    );
  }
}
