import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
    : super(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return widget;
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
           );
         }
      );
}

class ScaleRoute extends PageRouteBuilder {
  final Widget widget;
  ScaleRoute({this.widget})
    : super(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return widget;
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return new ScaleTransition(
            scale: new Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Interval(
                    0.00,
                    0.50,
                    curve: Curves.linear,
                  ),
                ),
              ),
            child: ScaleTransition(
                     scale: Tween<double>(
                       begin: 1.5,
                       end: 1.0,
                     ).animate(
                       CurvedAnimation(
                         parent: animation,
                         curve: Interval(
                           0.50,
                           1.00,
                           curve: Curves.linear,
                         ),
                       ),
                     ),
                     child: child,
                   ),
           );
         }
      );
}

class ModalView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        //automaticallyImplyLeading: false,
        // leading: Builder(
        //   builder: (context){
        //     return Center(
        //       child:,
        //     );
        //   },
        // ),
        title: Text('modal'),
      ),
      body: Container(
        //height: 1200,
      ),
    );
  }
}

class Home extends StatelessWidget {
  void _showModalAction(BuildContext context) {
    final v = ModalView();
    Navigator.push(
      context,
      SlideRightRoute(widget: v)
      //MaterialPageRoute(builder: (context) => )
    );
  
    // showGeneralDialog(
    //   context: context,
    //   pageBuilder: (context, animation, animation2) {
    //     return  ModalView();
    //   }
    // );
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return ModalView();
    //     return Dialog(
    //       child: Text('Dialog.'),
    //     );
    //   }
    // );
    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return ModalView();
    //   }
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: Center(
        child: RaisedButton(
            child: Text('Show dialog!'),
            onPressed: () {
              _showModalAction(context);
            }),
      ),
    );
  }
}

class ShowModalView extends StatelessWidget {

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
      home: Home()
    );
  }
}

