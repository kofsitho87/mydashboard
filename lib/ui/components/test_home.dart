import 'package:flutter/material.dart';
import 'package:easy_listview/easy_listview.dart';

class HomeView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {},
      ),
      body: EasyListView(
        itemCount: 10,
        itemBuilder: (context, index){
          return ListTile(
            leading: Icon(Icons.list),
            title: Text('title'),
            trailing: Text('3'),
            onTap: () => {},
          );
        },
        footerBuilder: (context) {
          return ListTile(
            leading: Icon(Icons.add),
            title: Text('카테고리 추가'),
            //trailing: Text('3'),
            onTap: () => {},
          );
        },
      ),
    );
  }
}

class TestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800],
        accentColor: Colors.lightGreen,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
          headline: TextStyle(color: Colors.white),
        )
      ),
      home: HomeView(),
    );
  }
}