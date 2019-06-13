import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc/bloc.dart';
import '../models/models.dart';

class DetailPageRoute extends CupertinoPageRoute {
  final String title;
  Todo todo;

  DetailPageRoute({@required this.title, this.todo})
      : super(builder: (BuildContext context) => DetailApp(title: title, todo: todo));


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: DetailApp(title: title, todo: todo));
  }
}

class DetailApp extends StatefulWidget {
  final String title;
  Todo todo;
  DetailApp({@required this.title, this.todo});

  @override
  State<StatefulWidget> createState() => _DetailApp(title: title);
}

class _DetailApp extends State<DetailApp> {
  final String title;
  _DetailApp({@required this.title});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TodosBloc todosBloc;

  //String _todoTitle;
  DateTime _completeDate;
  String _category;
  final categories = [];

  final todoTitleController = TextEditingController();
  final noteConttroller = TextEditingController();

  @override
  void initState() {
    todosBloc = BlocProvider.of<TodosBloc>(context);
    if(widget.todo != null){
      todoTitleController.text = widget.todo.title;
      _completeDate = widget.todo.completeDate;
      _category = widget.todo.category;
      noteConttroller.text = widget.todo.note;
    }
    super.initState();
  }

  void addTodo(String title, String category, DateTime completeDate, String note) {
    final todo = Todo(title, category, completeDate: completeDate, note: note);
    todosBloc.dispatch(AddTodo(todo));
    Navigator.of(context).pop();
    // setState(() {
    //   todoTitleController.text = '';
    //   _category = null;
    //   _completeDate = null;
    // });
  }

  void _showTimePicker(){
    DatePicker.showDatePicker(context, 
      showTitleActions: true,
      currentTime: _completeDate == null ? DateTime.now() : _completeDate,
      theme: DatePickerTheme(
        //backgroundColor: Theme.of(context).primaryColor
      ),
      locale: LocaleType.ko,
      minTime: DateTime.now(),
      onConfirm: (date) {
        print('confirm $date');
        setState(() {
          _completeDate = date;
        });
      },
      // onChanged: (date) {
      //   print('confirm $date');
      // }
    );
  }

  void _saveTodoAction(){
    if( todoTitleController.text.length < 1 ){
      final snackBar = SnackBar(content: Text('할일을 입력해주세요!!'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }else if ( _category == null ){
      final snackBar = SnackBar(content: Text('카테고리를 선택해주세요!!'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    var completeDate = null;
    if(_completeDate != null){
      completeDate = _completeDate.add(Duration(hours: 23, minutes: 59, seconds: 59));
    }
    this.addTodo(todoTitleController.text, _category, completeDate, noteConttroller.text);
  }

  void _updateTodoAction(){
    if( todoTitleController.text.length < 1 ){
      final snackBar = SnackBar(content: Text('할일을 입력해주세요!!'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    
    final todo = Todo(todoTitleController.text, _category, 
      completeDate: _completeDate == null ? null : _completeDate.add(Duration(hours: 23, minutes: 59, seconds: 59)), 
      id: widget.todo.id, 
      createdDate: widget.todo.createdDate,
      completed: widget.todo.completed,
      note: noteConttroller.text,
    );
    
    todosBloc.dispatch(UpdateTodo(todo));
    Navigator.of(context).pop();
  }

  Widget get _todoTitleRow {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 58, 66, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: todoTitleController,
        decoration: InputDecoration(
          icon: Icon(Icons.work, color: Colors.white),
          labelText: '할일',
          labelStyle: TextStyle(color: Colors.white),
          //hintText: '청소하기',
          border: InputBorder.none,
        ),
        validator: (String arg) {
          if (arg.length < 1)
            return '1글자 이상 입력해주세요!';
          else
            return null;
        },
        // onSaved: (String value) {
        //   print(value);
        //   _todoTitle = value;
        // },
        // onFieldSubmitted: (String value) {
        //   _todoTitle = value;
        //   print('onFieldSubmitted $value');
        // },
      ),
    );
  }

  Widget get _completeDateRow {
    final _completeDateStr = _completeDate != null ? DateFormat('yyyy-MM-dd').format(_completeDate) : '';
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 58, 66, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 10,
            child: Icon(Icons.calendar_today, color: Colors.white),
          ),
          Positioned(
            left: 42,
            top: 16,
            child: Text('완료설정', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Positioned(
            right: 20,
            top: 16,
            child: Text(_completeDateStr, style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          MaterialButton(
            //textTheme: ButtonTextTheme.primary,
            textColor: Colors.white,
            minWidth: double.infinity,
            onPressed: _showTimePicker,
            //child: Text('완료일 설정', style: TextStyle()),
          )
        ],
      ),
    );
  }

  Widget get _categoryRow {
    final categories = todosBloc.currentState is TodosLoaded ? (todosBloc.currentState as TodosLoaded).categories.map((Category c) {
      return DropdownMenuItem(value: c.title, child: Text(c.title, style: TextStyle(color: Colors.grey)));
    }).toList()
    : null;
    // final categories = this.categories.length > 0 ? this.categories.map((String value) {
    //   return DropdownMenuItem(value: value, child: Text(value, style: TextStyle(color: Colors.grey)));
    // }).toList() : [].toList();
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 58, 66, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.category, color: Colors.white),
          SizedBox(width: 20),
          Expanded(
            child: DropdownButtonFormField(
              value: _category,
              hint: Text('카테고리를 선택해주세요', style: TextStyle(color: Colors.white)),
              decoration: const InputDecoration(
                // filled: true,
                // fillColor: Colors.black,
                // hintStyle: TextStyle(color: Colors.white),
                // labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none)
              ),
              items: categories,
              onChanged: (value) {
                print(value);
                setState(() {
                    _category = value;
                });
              }
            ),
          )
        ],
      ),
    );
  }

  Widget get _completeRowView {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 58, 66, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.check_box, color: Colors.white),
          SizedBox(width: 20),
          Text('완료하기', style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      )
    );
  }

  Widget get _noteRowView {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(45, 58, 66, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: noteConttroller,
        style: TextStyle(color: Colors.white),
        //initialValue: widget.todo != null ? widget.todo.note : '',
        //key: ArchSampleKeys.noteField,
        maxLines: null,
        //style: textTheme.subhead,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.note, color: Colors.white),
          //hintText: localizations.notesHint,
          labelText: '노트',
          labelStyle: TextStyle(color: Colors.white),
        ),
        //onSaved: (value) => _note = value,
      )
    );
  }

  Widget get _formView {
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                _todoTitleRow,
                _completeDateRow,
                _categoryRow,
                _noteRowView,
              ],
            ),
            MaterialButton(
              padding: EdgeInsets.symmetric(vertical: 12),
              minWidth: double.infinity,
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              child: Text(widget.todo == null ? '생성' : '업데이트', style: TextStyle(fontSize: 20)),
              onPressed: widget.todo == null ? _saveTodoAction : _updateTodoAction,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: todosBloc,
      builder: (BuildContext context, TodosState state) {
        return ModalProgressHUD(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              elevation: 0,
              bottomOpacity: 0,
              centerTitle: true,
              title: Text(title),
            ),
            body: SingleChildScrollView(
              child: _formView,
            ),
          ),
          inAsyncCall: !(state is TodosLoaded),
        );
      }
    );
  }
}
