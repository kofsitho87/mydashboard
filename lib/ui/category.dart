import 'package:flutter/material.dart';
import 'package:easy_listview/easy_listview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../routes/index.dart';
import './todos.dart';
import '../bloc/blocs.dart';
import '../models/models.dart';

import 'components/show_modal.dart';
import './add_category.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoApp(category))
    );
  }

  void _navigateToCategoryAdd({Category category}){
    // Navigator.push(
    //   context,
    //   SlideRightRoute(widget: AddCategoryApp())
    // );
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryApp(currentCategory: category);
      }
    );
  }

  void _deleteCategory(Category category){
    categoriesBloc.dispatch(DeleteCategory(category));
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

  void _showBottomMenu(Category category){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.navigate_next),
                title: Text('수정하기'),
                onTap: () {
                  Navigator.of(context).pop();
                  _navigateToCategoryAdd(category: category);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제하기'),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteCategory(category);
                },
              )
            ],
          ),
        );
      }
    );
  }

  Future<bool> _confirmDismissAction(direction, Category category) async {
    //_deleteCategory(category);
    //return false;
  }

  Widget listView(List<Category> categories) {
    return EasyListView(
      itemCount: categories.length,
      itemBuilder: (context, index){
        final category = categories[index];
        // return Dismissible(
        //   key: Key(category.uid),
        //   //confirmDismiss: (direction) => _confirmDismissAction(direction, category),
        //   direction: DismissDirection.endToStart,
        //   background: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 20),
        //     child: Align(
        //       alignment: Alignment.centerRight,
        //       child: Icon(Icons.delete, color: Colors.white),
        //     ),
        //   ),
        //   onDismissed: (DismissDirection direction) => _deleteCategory(category),
        //   child: ListTile(
        //     leading: Icon(Icons.list, color: Colors.white),
        //     title: Text(category.title, style: TextStyle(color: Colors.white, fontSize: 22)),
        //     trailing: Text("${category.todos.where((todo) => !todo.completed).length}", style: TextStyle(color: Colors.white)),
        //     onTap: () => _navigateToTodos(category),
        //   ),
        // );

        return ListTile(
          leading: Icon(Icons.list, color: Colors.white),
          title: Text(category.title, style: TextStyle(color: Colors.white, fontSize: 22)),
          trailing: Text("${category.todos.where((todo) => !todo.completed).length}", style: TextStyle(color: Colors.white)),
          onTap: () => _navigateToTodos(category),
          onLongPress: () => _showBottomMenu(category),
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
        onPressed: () => Navigator.pushNamed(context, Routes.addTodo),
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
            //var categories = [].toList();
            if(state is CategoriesLoading){
              return Center(child: CircularProgressIndicator());
            }else if (state is CategoriesLoaded){
              //categories = state.categories;
              return listView(state.categories);
            }
            
            return listView([]);
          },
        ),
      ),
    );
  }
}