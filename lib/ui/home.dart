import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../resources/file_stroage.dart';
import '../resources/todos_repository.dart';
import '../bloc/blocs.dart';

import '../routes/index.dart';
import './category.dart';
//import './todos.dart';
import './detail.dart';
import './note.dart';


class HomeApp extends StatefulWidget {
  final AuthBloc authBloc;
  HomeApp({@required this.authBloc});

  @override
  State<StatefulWidget> createState() => _HomeApp();
}

class _HomeApp extends State<HomeApp> {
  CategoriesBloc categoriesBloc;
  
  @override
  void initState() {
    categoriesBloc = CategoriesBloc(todosRepository: TodosRepository(
      fileStorage: const FileStorage(
        '__Todos__',
        getApplicationDocumentsDirectory,
      )
    ));
    super.initState();
  }

  @override
  void dispose() {
    categoriesBloc.dispose();
    super.dispose();
  }

  Widget get appView {
    return MaterialApp(
      theme: ThemeData(
        //primaryColor: Colors.white,
        //primarySwatch: Colors.white10,
        accentColor: Colors.white,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            //color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 26
          ),
          //headline: TextStyle(color: Colors.white),
        )
      ),
      initialRoute: Routes.category,
      routes: {
        Routes.category: (context) {
          return CategoryApp(onSignOut: () {
            widget.authBloc.dispatch(SignOutEvent());
          }, authBloc: widget.authBloc);
        },
        // Routes.todos: (context) {
        //   return TodoApp(onSignOut: () {
        //     widget.authBloc.dispatch(SignOutEvent());
        //   }, authBloc: widget.authBloc);
        // },
        Routes.addTodo: (context) {
          return DetailApp(title: 'Todo 생성');
        },
        Routes.addNote: (context) {
          return NotePage();
        },
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    categoriesBloc.dispatch(LoadCategories());
    return BlocProvider(
      bloc: categoriesBloc,
      child: appView,
    );
  }
}