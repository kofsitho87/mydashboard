import 'package:flutter/material.dart';

class BackgroundContainerView extends StatelessWidget {
  final Widget child;
  BackgroundContainerView({@required this.child});

  Widget get bodyView {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        // Box decoration takes a gradient
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
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return bodyView;
    // return GestureDetector(
    //   child: bodyView,
    //   onTap: () {
    //     Navigator.of(context).pop();
    //   },
    // );
  }
}
