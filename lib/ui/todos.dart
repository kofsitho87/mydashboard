import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_listview/easy_listview.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../routes/index.dart';
import '../bloc/blocs.dart';
import '../models/models.dart';

import '../ui/components/index.dart';
import './detail.dart';


class TodoApp extends StatelessWidget {
  // final void Function() onSignOut;
  // AuthBloc authBloc;
  final Category category;
  TodoApp(this.category, {Key key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  BuildContext context;
  CategoriesBloc categoriesBloc;
  //TodosBloc todosBloc;
  FilteredTodosBloc filteredTodosBloc;

  void toggleCompleteTodo(Todo todo){
    todo.completed = !todo.completed;
    categoriesBloc.dispatch(UpdatedTodo(category, todo));
    final sn = SnackBar(content: Text("${todo.title} ${!todo.completed ? '미' : ''}완료됨"), duration: Duration(milliseconds: 200));
    _scaffoldKey.currentState.showSnackBar(sn);
  }

  void deleteTodo(Todo todo) {
    categoriesBloc.dispatch(DeleteTodo(category, todo));
    final sn = SnackBar(content: Text("${todo.title} dismissed"), duration: Duration(milliseconds: 200));
    _scaffoldKey.currentState.showSnackBar(sn);
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
                  //final page = DetailPageRoute(title: todo.title, todo: todo);
                  final page = MaterialPageRoute(builder: (context) => DetailApp(title: todo.title, todo: todo));
                  Navigator.of(bc).push(page);
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
      category.todos.length > 1 : 
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
                  filteredTodosBloc.dispatch(UpdateFilter(category, VisibilityFilter.all));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: activeFilter == VisibilityFilter.active ? Icon(Icons.check_circle) : null,
                enabled: enabled && activeFilter != VisibilityFilter.active,
                title: Text('미완료만 보기'),
                onTap: () {
                  filteredTodosBloc.dispatch(UpdateFilter(category, VisibilityFilter.active));
                  //filteredTodosBloc.dispatch(VisibilityTodos(VisibilityFilter.active));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: activeFilter == VisibilityFilter.completed ? Icon(Icons.check_circle) : null,
                enabled: enabled && activeFilter != VisibilityFilter.completed,
                title: Text('완료만 보기'),
                onTap: () {
                  filteredTodosBloc.dispatch(UpdateFilter(category, VisibilityFilter.completed));
                  //filteredTodosBloc.dispatch(VisibilityTodos(VisibilityFilter.completed));
                  Navigator.of(context).pop();
                },
              ),
              // ListTile(
              //   enabled: enabled,
              //   //leading: Icon(Icons.filter_hdr),
              //   title: Text('완료 시간순으로 정렬'),
              //   onTap: () {
              //     filteredTodosBloc.dispatch(SortingTodos(SortingFilter.completeDate));
              //     Navigator.of(context).pop();
              //   },
              // ),
              // ListTile(
              //   enabled: enabled,
              //   //leading: Icon(Icons.navigate_next),
              //   title: Text('미완료/완료로 정렬'),
              //   onTap: () {
              //     filteredTodosBloc.dispatch(SortingTodos(SortingFilter.activeCompleted));
              //     Navigator.of(context).pop();
              //   },
              // )
            ],
          ),
        );
      }
    );
  }

  void _showCategoryFilterList(context) {
    // final list = (todosBloc.currentState as TodosLoaded).categories.map((row) {
    //   final content = ListTile(
    //     title: Text(row.title),
    //     onTap: () {
    //       // filteredTodosBloc.dispatch(SortingTodos(SortingFilter.activeCompleted));
    //       Navigator.of(context).pop();
    //     },
    //   );

    //   return Column(
    //     children: <Widget>[
    //       content,
    //       Divider()
    //     ],
    //   );
    // }).toList();
    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext bc) {
    //     return Container(
    //       padding: EdgeInsets.only(bottom: 10),
    //       child: Wrap(
    //         children: list,
    //       ),
    //     );
    //   }
    // );
  }

  // Future<bool> _confirmDismissAction(direction) async {
  //   return false;
  //   return direction == DismissDirection.endToStart;
  // }

  // Widget _listView(todos) {
  //   return ListView.builder(
  //     itemCount: todos.length,
  //     itemBuilder: (context, index) {
  //       final todo = todos[index];
  //       return GestureDetector(
  //         child: AnimatedOpacity(
  //           key: Key(index.toString()),
  //           opacity: todo.completed ? 0.4 : 1,
  //           duration: Duration(milliseconds: 200),
  //           child: TodoRowView(todo),
  //         ),
  //         onTapUp: (_) => _showTodoBottomSheet(todo, context),
  //       );

  //       // return Dismissible(
  //       //   key: Key(index.toString()),
  //       //   confirmDismiss: _confirmDismissAction,
  //       //   direction: DismissDirection.endToStart,
  //       //   background: Container(
  //       //     margin: EdgeInsets.symmetric(vertical: 5),
  //       //     padding: EdgeInsets.only(left: 20.0),
  //       //     color: Colors.blue,
  //       //     child: Align(
  //       //       alignment: Alignment.centerLeft,
  //       //       child: Icon(Icons.delete, color: Colors.white)
  //       //     ),
  //       //   ),
  //       //   secondaryBackground: Container(
  //       //     margin: EdgeInsets.symmetric(vertical: 5),
  //       //     padding: EdgeInsets.only(right: 20.0),
  //       //     color: Colors.red,
  //       //     child: Align(
  //       //       alignment: Alignment.centerRight,
  //       //       child: Icon(Icons.delete, color: Colors.white)
  //       //     ),
  //       //   ),
  //       //   onDismissed: (DismissDirection direction) {
  //       //     if(direction == DismissDirection.endToStart){
  //       //       deleteTodo(todo);
  //       //     }
  //       //   },
  //       //   child: GestureDetector(
  //       //     child: AnimatedOpacity(
  //       //       key: Key(index.toString()),
  //       //       opacity: todo.completed ? 0.4 : 1,
  //       //       duration: Duration(milliseconds: 200),
  //       //       child: TodoRowView(index, todo),
  //       //     ),
  //       //     onTapUp: (_) => _showTodoBottomSheet(todo, context),
  //       //   ),
  //       // );
  //     }
  //   );
  // }

  Widget get progressView{
    return BlocBuilder(
      bloc: filteredTodosBloc,
      builder: (BuildContext context, FilteredTodosState state) {
        var completePercent = 0.0;
        if(state is FilteredTodosLoaded){
          final completeTodos = state.filteredTodos.where((todo) => todo.completed).length;
          completePercent = state.filteredTodos.length > 0 ? completeTodos / state.filteredTodos.length : 0;
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
            child: TodoRowView(todo, onToggleComplteTodoAction: toggleCompleteTodo),
          ),
          //onTapUp: (_) => _showTodoBottomSheet(todo, context),
          onTapUp: (_) {
            final page = MaterialPageRoute(builder: (context) => DetailApp(title: todo.title, todo: todo));
            Navigator.of(context).push(page);
          },
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
    categoriesBloc = BlocProvider.of<CategoriesBloc>(context);
    filteredTodosBloc = FilteredTodosBloc(categoriesBloc, category);

    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(209, 126, 242, 0.69),
        title: Text(category.title),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterListBottomSheet(context),
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
          bloc: filteredTodosBloc,
          builder: (BuildContext context, FilteredTodosState state) {
            if(state is FilteredTodosLoaded) {
              final todos = state.filteredTodos;
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  _refreshIndicatorKey.currentState.show();
                  //todosBloc.dispatch(LoadTodos());
                  return null;
                },
                child: _easyListView(todos),
              );
            }
            return Center(child: CircularProgressIndicator());
          }
        ),
      )
      
    );
  }
}