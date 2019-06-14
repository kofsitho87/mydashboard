import 'package:flutter/material.dart';
import 'package:easy_listview/easy_listview.dart';

class HomeView2 extends StatelessWidget{
  Widget get listView {
    return EasyListView(
      itemCount: 10,
      itemBuilder: (context, index) {
        //final icon = Icon(Icons.check_circle, color: Colors.white);
        final icon = Icon(index%2 == 0 ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.white, size: 30);
        final button = IconButton(
          icon: icon,
          onPressed: () => {},
        );

        final text = index == 1 ? 'lfklskdf ldkslk flskdfk sl d kl kfld kf lkd flkd flks dl dkflsk dlf ksldkfls kdlf ksl dkfl skdflk' : 'Biking';
        return ListTile(
          //leading: Icon(Icons.list, color: Colors.white),
          title: Text(text, 
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
          ),
          subtitle: Column(
            children: <Widget>[
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Icon(Icons.access_time, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text('Today', style: TextStyle(color: Colors.white, fontSize: 16))
                ],
              )
            ],
          ),
          trailing: button,
          onTap: () => {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(209, 126, 242, 0.69),
        centerTitle: false,
        title: Text('Personal'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.tune, color: Colors.white),
            onPressed: () => {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {},
      ),
      body: Container(
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
        child: listView,
      ),
    );
  }
}

class HomeView extends StatelessWidget{
  BuildContext context;

  void _navigate(context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeView2())
    );
  }

  Widget get listView {
    return EasyListView(
      // headerBuilder: (context) {
      //   return Padding(
      //     padding: EdgeInsets.only(
      //       top: 20,
      //       left: 20,
      //       bottom: 20,
      //       right: 0,
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Text('Hee Wung', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
      //         IconButton(
      //           iconSize: 30,
      //           icon: Icon(Icons.exit_to_app, color: Colors.white),
      //           onPressed: () => {},
      //         )
      //       ],
      //     ),
      //   );
      // },
      itemCount: 10,
      itemBuilder: (context, index){
        return ListTile(
          leading: Icon(Icons.list, color: Colors.white),
          title: Text('title', style: TextStyle(color: Colors.white, fontSize: 22)),
          trailing: Text('3', style: TextStyle(color: Colors.white)),
          onTap: () => _navigate(this.context),
        );
      },
      footerBuilder: (context) {
        return ListTile(
          leading: Icon(Icons.add, color: Colors.white),
          title: Text('카테고리 추가', style: TextStyle(color: Colors.white, fontSize: 22)),
          //trailing: Text('3'),
          onTap: () => {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(209, 126, 242, 0.69),
        centerTitle: false,
        title: Text('Hee Wung'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => {},
          )
        ],
        //elevation: 0,
        //bottomOpacity: 0,
        //toolbarOpacity: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {},
      ),
      body: Container(
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
        child: listView,
      ),
    );
  }
}

class TestHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        //primaryColor: Color.fromRGBO(209, 126, 242, 0.69),
        accentColor: Colors.white,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
          //headline: TextStyle(color: Colors.red),
        )
      ),
      home: HomeView(),
    );
  }
}