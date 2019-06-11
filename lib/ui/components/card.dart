import 'package:flutter/material.dart';

Widget get CustomCardView {
  return Center(
    child: Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          width: 300,
          height: 100,
          child: Text('A card that can be tapped'),
        ),
      ),
    )
  );
}