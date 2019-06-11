import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import '../ui/components/components.dart';

class MainApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Text('A', style: TextStyle(fontSize: 30.0, color: Colors.amber),)
          ),
          Center(child: Text('B')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text("Home"),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text("Profile"),
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}