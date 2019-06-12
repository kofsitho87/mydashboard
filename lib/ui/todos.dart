import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_listview/easy_listview.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../routes/index.dart';
import '../bloc/blocs.dart';
import '../models/models.dart';

import '../ui/components/components.dart';
import './detail.dart';


class TodoApp extends StatelessWidget {
  final void Function() onSignOut;
  AuthBloc authBloc;
  TodoApp({@required this.onSignOut, this.authBloc, Key key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  BuildContext context;
  TodosBloc todosBloc;
  FilteredTodosBloc filteredTodosBloc;

  void toggleCompleteTodo(Todo todo){
    todo.completed = !todo.completed;
    todosBloc.dispatch(UpdateTodo(todo));
    final sn = SnackBar(content: Text("${todo.title} ${!todo.completed ? '미' : ''}완료됨"), duration: Duration(milliseconds: 200));
    _scaffoldKey.currentState.showSnackBar(sn);
  }

  void deleteTodo(Todo todo) {
    todosBloc.dispatch(DeleteTodo(todo));
    final sn = SnackBar(content: Text("${todo.title} dismissed"), duration: Duration(milliseconds: 200));
    _scaffoldKey.currentState.showSnackBar(sn);
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
              child: Text('확인'),
              onPressed: (){
                onSignOut();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('닫기'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  void _showTodoBottomSheet(Todo todo, context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text( todo.completed ? '미완료하기' : '완료하기' ),
                onTap: () {
                  Navigator.of(context).pop();
                  toggleCompleteTodo(todo);
                },
              ),
              ListTile(
                leading: Icon(Icons.navigate_next),
                title: Text('수정하기'),
                onTap: () {
                  Navigator.of(context).pop();
                  final page = DetailPageRoute(title: todo.title, todo: todo);
                  Navigator.of(context).push(page);
                  //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetailApp(title: todo.title, todo: todo)));
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('삭제하기'),
                onTap: () {
                  Navigator.of(context).pop();
                  deleteTodo(todo);
                },
              )
            ],
          ),
        );
      }
    );
  }

  void _showFilterListBottomSheet(context){
    final enabled = (filteredTodosBloc.currentState is FilteredTodosLoaded) ? 
      (todosBloc.currentState as TodosLoaded).todos.length > 1 : 
      false;
    final activeFilter = (filteredTodosBloc.currentState as FilteredTodosLoaded).activeFilter;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: activeFilter == VisibilityFilter.all ? Icon(Icons.check_circle) : null,
                enabled: enabled && activeFilter != VisibilityFilter.all,
                title: Text('전체보기'),
                onTap: () {
                  //filteredTodosBloc.dispatch(SortingTodos(SortingFilter.basic));
                  filteredTodosBloc.dispatch(UpdateFilter(VisibilityFilter.all));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: activeFilter == VisibilityFilter.active ? Icon(Icons.check_circle) : null,
                enabled: enabled && activeFilter != VisibilityFilter.active,
                title: Text('미완료만 보기'),
                onTap: () {
                  filteredTodosBloc.dispatch(UpdateFilter(VisibilityFilter.active));
                  //filteredTodosBloc.dispatch(VisibilityTodos(VisibilityFilter.active));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: activeFilter == VisibilityFilter.completed ? Icon(Icons.check_circle) : null,
                enabled: enabled && activeFilter != VisibilityFilter.completed,
                title: Text('완료만 보기'),
                onTap: () {
                  filteredTodosBloc.dispatch(UpdateFilter(VisibilityFilter.completed));
                  //filteredTodosBloc.dispatch(VisibilityTodos(VisibilityFilter.completed));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                enabled: enabled,
                //leading: Icon(Icons.filter_hdr),
                title: Text('완료 시간순으로 정렬'),
                onTap: () {
                  filteredTodosBloc.dispatch(SortingTodos(SortingFilter.completeDate));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                enabled: enabled,
                //leading: Icon(Icons.navigate_next),
                title: Text('미완료/완료로 정렬'),
                onTap: () {
                  filteredTodosBloc.dispatch(SortingTodos(SortingFilter.activeCompleted));
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
    );
  }

  Future<bool> _confirmDismissAction(direction) async {
    return false;
    return direction == DismissDirection.endToStart;
  }

  Widget _listView(todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return GestureDetector(
          child: AnimatedOpacity(
            key: Key(index.toString()),
            opacity: todo.completed ? 0.4 : 1,
            duration: Duration(milliseconds: 200),
            child: TodoRowView(index, todo),
          ),
          onTapUp: (_) => _showTodoBottomSheet(todo, context),
        );

        // return Dismissible(
        //   key: Key(index.toString()),
        //   confirmDismiss: _confirmDismissAction,
        //   direction: DismissDirection.endToStart,
        //   background: Container(
        //     margin: EdgeInsets.symmetric(vertical: 5),
        //     padding: EdgeInsets.only(left: 20.0),
        //     color: Colors.blue,
        //     child: Align(
        //       alignment: Alignment.centerLeft,
        //       child: Icon(Icons.delete, color: Colors.white)
        //     ),
        //   ),
        //   secondaryBackground: Container(
        //     margin: EdgeInsets.symmetric(vertical: 5),
        //     padding: EdgeInsets.only(right: 20.0),
        //     color: Colors.red,
        //     child: Align(
        //       alignment: Alignment.centerRight,
        //       child: Icon(Icons.delete, color: Colors.white)
        //     ),
        //   ),
        //   onDismissed: (DismissDirection direction) {
        //     if(direction == DismissDirection.endToStart){
        //       deleteTodo(todo);
        //     }
        //   },
        //   child: GestureDetector(
        //     child: AnimatedOpacity(
        //       key: Key(index.toString()),
        //       opacity: todo.completed ? 0.4 : 1,
        //       duration: Duration(milliseconds: 200),
        //       child: TodoRowView(index, todo),
        //     ),
        //     onTapUp: (_) => _showTodoBottomSheet(todo, context),
        //   ),
        // );
        
      }
    );
  }

  Widget get progressView{
    return BlocBuilder(
      bloc: todosBloc,
      builder: (BuildContext context, TodosState state) {
        var completePercent = 0.0;
        if(state is TodosLoaded && state.todos.length > 1){
          final completeTodos = state.todos.where((todo) => todo.completed).toList().length;
          completePercent = completeTodos / state.todos.length;
        }
        return CircularPercentIndicator(
          radius: 160.0,
          lineWidth: 14.0,
          percent: completePercent,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${(completePercent * 100).round()}%", style: TextStyle(fontSize: 30, color: Colors.white)),
              SizedBox(height: 5),
              Text('완료율', style: TextStyle(fontSize: 16, color: Colors.white))
            ],
          ),
          progressColor: Theme.of(context).accentColor,
          animation: true,
          animationDuration: 400,
          circularStrokeCap: CircularStrokeCap.round,
        );
      },
    );
    // return CircularPercentIndicator(
    //   radius: 180.0,
    //   lineWidth: 15.0,
    //   percent: 0.5,
    //   center: Text("100%", style: TextStyle(fontSize: 30, color: Colors.white)),
    //   progressColor: Theme.of(context).accentColor,
    //   //fillColor: Colors.redAccent,
    //   //backgroundColor: Colors.transparent,
    //   //header: Text('header'),
    //   //footer: Text('footer'),
    //   animation: true,
    //   animationDuration: 600,
    //   circularStrokeCap: CircularStrokeCap.round,
    //   //linearGradient: LinearGradient(),
    //   //arcType: ArcType.FULL
    // );
  }

  Widget _easyListView(todos){
    return EasyListView(
      //headerSliverBuilder: (BuildContext context, ),   // SliverAppBar...etc.
      headerBuilder: (BuildContext context){
        return Container(
          padding: EdgeInsets.only(
            bottom: 30,
          ),
          child: progressView,
        );
      },               // Header Widget Builder
      //footerBuilder: footerBuilder,               // Footer Widget Builder 
      itemCount: todos.length,
      itemBuilder: (BuildContext context, index){
        final todo = todos[index];
        return GestureDetector(
          child: AnimatedOpacity(
            key: Key(index.toString()),
            opacity: todo.completed ? 0.4 : 1,
            duration: Duration(milliseconds: 200),
            child: TodoRowView(index, todo),
          ),
          onTapUp: (_) => _showTodoBottomSheet(todo, context),
        );
      },                   // ItemBuilder with data index
      //dividerBuilder: dividerBuilder,             // Custom Divider Builder
      //loadMore: hasNextPage,                      // Load more flag
      //onLoadMore: onLoadMoreEvent,                // Load more callback
      //foregroundWidget: foregroundWidget,         // Widget witch overlap on ListView
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    todosBloc = BlocProvider.of<TodosBloc>(context);
    var userName = authBloc.currentState is Autenticated ? (authBloc.currentState as Autenticated).user.name : 'empty';
    userName = userName == null ? 'empty Name' : userName;
    
    filteredTodosBloc = FilteredTodosBloc(
      todosBloc: todosBloc
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        bottomOpacity: 0,
        //centerTitle: true,
        title: Text(userName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterListBottomSheet(context),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'add todo',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Routes.addTodo);
        },
      ),
      body: BlocBuilder(
        bloc: filteredTodosBloc,
        builder: (BuildContext context, FilteredTodosState state) {
          if(state is FilteredTodosLoaded) {
            final todos = state.filteredTodos;

            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                _refreshIndicatorKey.currentState.show();
                todosBloc.dispatch(LoadTodos());
                return null;
              },
              child: _easyListView(todos),
            );
          }

          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}