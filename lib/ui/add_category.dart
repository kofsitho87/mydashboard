import 'package:flutter/material.dart';

class AddCategory extends StatelessWidget {
  BuildContext context;

  Widget get formView {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: '카테고리 이름',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            MaterialButton(
              child: Text('추가'),
              onPressed: () => {},
            )
          ],
        ),
      ),
    );
  }

  Widget get headerView {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        //left: 20,
        right: 20,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text('카테고리 추가',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white))
        ],
      ),
    );
  }

  Widget get bodyView {
    return Column(
      children: <Widget>[
        //headerView, 
        formView
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(209, 126, 242, 0.69),
        centerTitle: false,
        title: Text('카테고리 추가'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
        body: Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0, 0.7],
          colors: [
            Color.fromRGBO(209, 126, 242, 0.69),
            Color.fromRGBO(129, 92, 206, 1)
          ],
        ),
      ),
      child: bodyView,
    ));
  }
}
