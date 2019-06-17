import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './components/background_container.dart';
import './colors.dart';
import '../bloc/blocs.dart';
import '../models/models.dart';

class DetailPageRoute extends CupertinoPageRoute {
  final String title;
  Todo todo;

  DetailPageRoute({@required this.title, this.todo})
      : super(
            builder: (BuildContext context) =>
                DetailApp(title: title, todo: todo));

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
        opacity: animation, child: DetailApp(title: title, todo: todo));
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
  CategoriesBloc categoriesBloc;

  DateTime _completeDate;
  String _category;
  List<Category> categories = [];
  bool isShowKeyboard = false;

  final todoTitleController = TextEditingController();
  final noteConttroller = TextEditingController();
  final focus = FocusNode();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  KeyboardVisibilityNotification keyboardNoti;

  @override
  void initState() {
    categoriesBloc = BlocProvider.of<CategoriesBloc>(context);
    if (widget.todo != null) {
      todoTitleController.text = widget.todo.title;
      _completeDate = widget.todo.completeDate;
      _category = widget.todo.category.uid;
      noteConttroller.text = widget.todo.note;
    }
    this.categories = categoriesBloc.currentState is CategoriesLoaded
        ? (categoriesBloc.currentState as CategoriesLoaded).categories
        : [];

    var android = AndroidInitializationSettings('@mipmap/ic_launher');
    var ios = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotofication);

    super.initState();

    keyboardNoti = KeyboardVisibilityNotification();
    keyboardNoti.addNewListener(
      onChange: (bool visible) {
        //print("visible $visible");
        isShowKeyboard = visible;
      },
    );
  }

  @override
  void dispose(){
    keyboardNoti.dispose();
    super.dispose();
  }

  Future _showNotificationAtTime(Todo todo) async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 3));
    //final scheduledNotificationDateTime = todo.completeDate.subtract( Duration(seconds: 3) );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        sound: 'slow_spring_board',
        importance: Importance.Max,
        priority: Priority.High);

    var iosPlatformChannelSpecifics = IOSNotificationDetails(sound: 'slow_spring.board.aiff');
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);

    
    await _flutterLocalNotificationsPlugin.schedule(
      1,
      todo.title,
      '',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: todo.title,
    );
  }

  Future _onSelectNotofication(String payload) async {
    //print(payload);
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Notification Payload'),
              content: Text('Payload: $payload'),
            ));
  }

  void addTodo(
      String title, String categoryId, DateTime completeDate, String note) {
    //final cate = Category(categoryId, '');
    final cate = this.categories.firstWhere((row) {
      return row.uid == categoryId;
    });

    final todo = Todo(title, cate, completeDate: completeDate, note: note);
    categoriesBloc.dispatch(AddTodo(cate, todo));

    if( completeDate != null ){
      _showNotificationAtTime(todo);
    }
  }

  void _showTimePicker() {
    DatePicker.showDatePicker(
      context,
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
    );
  }

  void _showDateTimePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      currentTime: _completeDate == null ? DateTime.now() : _completeDate,
      locale: LocaleType.ko,
      //minTime: DateTime.now(),
      onConfirm: (date) {
        print('confirm $date');
        setState(() {
          _completeDate = date;
        });
      },
    );
  }

  void _saveTodoAction() {
    if (todoTitleController.text.length < 1) {
      final snackBar = SnackBar(content: Text('할일을 입력해주세요!!'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    } else if (_category == null) {
      final snackBar = SnackBar(content: Text('카테고리를 선택해주세요!!'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    var completeDate;
    if (_completeDate != null) {
      completeDate =
          _completeDate.add(Duration(hours: 23, minutes: 59, seconds: 59));
    }
    this.addTodo(todoTitleController.text, _category, completeDate,
        noteConttroller.text);
  }

  void _updateTodoAction() {
    if (todoTitleController.text.length < 1) {
      final snackBar = SnackBar(content: Text('할일을 입력해주세요!!'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    final prevCategory = widget.todo.category;
    final cate = this.categories.firstWhere((cate) => cate.uid == _category);
    final todo = widget.todo;
    todo.category = cate;
    todo.title = todoTitleController.text;
    //todo.completeDate = _completeDate == null ? null : _completeDate.add(Duration(hours: 23, minutes: 59, seconds: 59));
    todo.completeDate = _completeDate;
    todo.note = noteConttroller.text;
    

    categoriesBloc.dispatch(UpdatedTodo(prevCategory, todo));
    
    if( _completeDate != null ){
      _showNotificationAtTime(todo);
    }
  }

  void _deleteTodoAction() {
    categoriesBloc.dispatch(DeleteTodo(widget.todo.category, widget.todo));
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
        focusNode: focus,
        //autofocus: true,
        autocorrect: false,
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
    final _completeDateStr = _completeDate != null
        ? DateFormat('yyyy-MM-dd').format(_completeDate)
        : '';
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
            child: Text('완료설정',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Positioned(
            right: 20,
            top: 16,
            child: Text(_completeDateStr,
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          MaterialButton(
              //textTheme: ButtonTextTheme.primary,
              textColor: Colors.white,
              minWidth: double.infinity,
              onPressed: _showDateTimePicker, //_showTimePicker,
              //child: Text('완료일 설정', style: TextStyle()),
              )
        ],
      ),
    );
  }

  Widget get _categoryRow {
    final _categories = this.categories.length > 0
        ? this.categories.map((Category c) {
            return DropdownMenuItem(
                value: c.uid,
                child: Text(c.title, style: TextStyle(color: Colors.grey)));
          }).toList()
        : null;

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
                hint:
                    Text('카테고리를 선택해주세요', style: TextStyle(color: Colors.white)),
                decoration: const InputDecoration(
                    // filled: true,
                    // fillColor: Colors.black,
                    // hintStyle: TextStyle(color: Colors.white),
                    // labelStyle: TextStyle(color: Colors.white),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none)),
                items: _categories,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    _category = value;
                  });
                }),
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
        ));
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
          autocorrect: false,
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
        ));
  }

  Widget get _formView {
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 50,
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
              //textColor: Colors.white,
              child: Text(widget.todo == null ? '생성' : '업데이트',
                  style: TextStyle(fontSize: 20)),
              onPressed:
                  widget.todo == null ? _saveTodoAction : _updateTodoAction,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deleteButton = IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => _deleteTodoAction(),
      //onPressed: () => _saveTodoAction(),
    );

    final actionIcons = widget.todo == null ? null : [deleteButton];

    return BlocListener(
      bloc: categoriesBloc,
      listener: (context, state) {
        if (state is SuccessAddTodo ||
            state is SuccessUpdateTodo ||
            state is SuccessDeleteTodo) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder(
          bloc: categoriesBloc,
          builder: (BuildContext context, CategoriesBlocState state) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(isShowKeyboard ? Icons.arrow_downward : Icons.arrow_back_ios),
                  onPressed: () {
                    isShowKeyboard ? FocusScope.of(context).requestFocus(focus) 
                    : Navigator.of(context).pop();
                  },
                ),
                backgroundColor: AppbarColor,
                centerTitle: false,
                title: Text(title),
                actions: actionIcons,
              ),
              body: BackgroundContainerView(
                  //child: _formView,
                  child: ModalProgressHUD(
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: constraints.copyWith(
                          minHeight: constraints.maxHeight,
                          maxHeight: double.infinity),
                      child: _formView,
                    ),
                  );
                }),
                inAsyncCall: state is TodosLoading,
              )),
            );
          }),
    );
  }
}
