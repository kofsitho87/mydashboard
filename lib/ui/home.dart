import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../resources/todos_repository.dart';
import '../bloc/blocs.dart';

import '../routes/index.dart';
import './todos.dart';
import './detail.dart';


class HomeApp extends StatefulWidget {
  final AuthBloc authBloc;
  HomeApp({@required this.authBloc});

  @override
  State<StatefulWidget> createState() => _HomeApp();
}

class _HomeApp extends State<HomeApp> {
  TodosBloc todosBloc;
  
  @override
  void initState() {
    todosBloc = TodosBloc(todosRepository: TodosRepository());
    super.initState();
  }

  @override
  void dispose() {
    todosBloc.dispose();
    super.dispose();
  }

  Widget get appView {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800],
        accentColor: Colors.lightGreen,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
          headline: TextStyle(color: Colors.white),
        )
      ),
      initialRoute: Routes.todos,
      routes: {
        Routes.todos: (context) {
          return TodoApp(onSignOut: () {
            widget.authBloc.dispatch(SignOutEvent());
          }, authBloc: widget.authBloc);
        },
        Routes.addTodo: (context) {
          return DetailApp(title: 'Add Todo');
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    todosBloc.dispatch(LoadTodos());
    return BlocProvider(
      bloc: todosBloc,
      child: appView,
    );
  }
}