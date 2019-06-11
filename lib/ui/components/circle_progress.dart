//import 'package:flutter/material.dart';
//import 'package:percent_indicator/percent_indicator.dart';
////import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//class CircleProgressUI extends StatelessWidget {
//
//  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
//  BuildContext context;
//
//  Future _showNotificationAtTime() async {
//    var scheduledNotificationDateTime =
//        new DateTime.now().add(new Duration(seconds: 5));
//
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      'your channel id', 'your channel name', 'your channel description',
//      sound: 'slow_spring_board',
//      importance: Importance.Max,
//      priority: Priority.High
//    );
//
//    var iosPlatformChannelSpecifics = IOSNotificationDetails(sound: 'slow_spring.board.aiff');
//    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
//
//    await _flutterLocalNotificationsPlugin.schedule(
//      1,
//      '지정 Notification',
//      '지정 Notification 내용',
//      DateTime.now().add(new Duration(seconds: 5)),
//      platformChannelSpecifics,
//      payload: 'Hello Flutter',
//    );
//  }
//
//  Future _showNotificationRepeat() async {
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      'your channel id', 'your channel name', 'your channel description',
//      sound: 'slow_spring_board',
//      importance: Importance.Max,
//      priority: Priority.High
//    );
//
//    var iosPlatformChannelSpecifics = IOSNotificationDetails(sound: 'slow_spring.board.aiff');
//    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
//
//    await _flutterLocalNotificationsPlugin.periodicallyShow(
//      1,
//      '반복 Notification',
//      '반복 Notification 내용',
//      RepeatInterval.EveryMinute,
//      platformChannelSpecifics,
//      payload: 'Hello Flutter',
//    );
//  }
//
//  Future _showNotificationWithSound() async {
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      'your channel id', 'your channel name', 'your channel description',
//      sound: 'slow_spring_board',
//      importance: Importance.Max,
//      priority: Priority.High
//    );
//
//    var iosPlatformChannelSpecifics = IOSNotificationDetails(sound: 'slow_spring.board.aiff');
//    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
//
//    await _flutterLocalNotificationsPlugin.show(
//      0,
//      '심플 Notification',
//      '이것은 Flutter 노티피케이션!',
//      platformChannelSpecifics,
//      payload: 'Hello Flutter',
//    );
//  }
//
//  Future _onSelectNotofication(String payload) async{
//    print(payload);
//    showDialog(
//      context: context,
//      builder: (_) => AlertDialog(
//        title: Text('Notification Payload'),
//        content: Text('Payload: $payload'),
//      )
//    );
//  }
//
//  Widget get progressView{
//    return CircularPercentIndicator(
//      radius: 200.0,
//      lineWidth: 15.0,
//      percent: 0.5,
//      center: Text("100%", style: TextStyle(fontSize: 30, color: Colors.white)),
//      progressColor: Colors.green,
//      //fillColor: Colors.redAccent,
//      //backgroundColor: Colors.transparent,
//      header: Text('header'),
//      footer: Text('footer'),
//      animation: true,
//      animationDuration: 1200,
//      //linearGradient: LinearGradient(),
//      circularStrokeCap: CircularStrokeCap.round,
//      //arcType: ArcType.FULL
//    );
//  }
//
//  Widget get bodyView {
//    return Container(
//      //color: Colors.white,
//      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
//      child: Column(
//        children: <Widget>[
//          progressView,
//          RaisedButton(
//            child: Text('Show Notification'),
//            onPressed: _showNotificationWithSound,
//          ),
//          RaisedButton(
//            child: Text('반복 Notification'),
//            onPressed: _showNotificationRepeat,
//          ),
//          RaisedButton(
//            child: Text('지정 Notification'),
//            onPressed: _showNotificationAtTime,
//          ),
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    this.context = context;
//
//    var android = AndroidInitializationSettings('@mipmap/ic_launher');
//    var ios = IOSInitializationSettings();
//    var initializationSettings = InitializationSettings(android, ios);
//    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotofication);
//
//    return MaterialApp(
//      theme: ThemeData(
//        primaryColor: Colors.blueGrey[800],
//        accentColor: Colors.lightGreen,
//        primaryTextTheme: TextTheme(
//          title: TextStyle(color: Colors.white),
//          headline: TextStyle(color: Colors.white),
//        ),
//      ),
//      home: Scaffold(
//        backgroundColor: Color.fromRGBO(49, 58, 67, 1),
//        body: Center(child: bodyView),
//      ),
//    );
//  }
//}