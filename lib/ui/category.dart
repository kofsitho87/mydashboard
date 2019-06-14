import 'package:flutter/material.dart';
import 'package:easy_listview/easy_listview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../routes/index.dart';
import './todos.dart';
import '../bloc/blocs.dart';
import '../models/models.dart';

import 'components/show_modal.dart';

class CategoryApp extends StatelessWidget{
  final void Function() onSignOut;
  AuthBloc authBloc;
  CategoryApp({@required this.onSignOut, this.authBloc, Key key}) : super(key: key);

  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  BuildContext context;
  CategoriesBloc categoriesBloc;

  void _navigateToTodos(Category category){
    //todosBloc.dispatch( ChangeCategory(category) );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TodoApp(category))
    // );
  }

  void _navigateToCategoryAdd(){
    Navigator.push(
      context,
      ScaleRoute(widget: Home())
    );
  }

  void _showLogoutDialog(context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('로그아웃 하시겠습니까?'),
          //content: Text('content'),
          actions: <Widget>[
            FlatButton(
              child: Text('확인', style: TextStyle(color: Colors.red)),
              onPressed: (){
                onSignOut();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('닫기', style: TextStyle(color: Colors.black)),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  Widget listView(List<Category> categories) {
    return EasyListView(
      itemCount: categories.length,
      itemBuilder: (context, index){
        final category = categories[index];
        return ListTile(
          leading: Icon(Icons.list, color: Colors.white),
          title: Text(category.title, style: TextStyle(color: Colors.white, fontSize: 22)),
          trailing: Text("${category.todos.length}", style: TextStyle(color: Colors.white)),
          onTap: () => _navigateToTodos(category),
        );
      },
      footerBuilder: (context) {
        return ListTile(
          leading: Icon(Icons.add, color: Colors.white),
          title: Text('카테고리 추가', style: TextStyle(color: Colors.white, fontSize: 22)),
          //trailing: Text('3'),
          onTap: () => _navigateToCategoryAdd(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    categoriesBloc = BlocProvider.of<CategoriesBloc>(context);
    var userName = authBloc.currentState is Autenticated ? (authBloc.currentState as Autenticated).user.name : 'empty';
    userName = userName == null ? 'empty Name' : userName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(209, 126, 242, 0.69),
        centerTitle: false,
        title: Text(userName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
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
        child: BlocBuilder(
          bloc: categoriesBloc,
          builder: (BuildContext context, CategoriesBlocState state) {
            if(state is CategoriesLoaded){
              return listView(state.categories);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}