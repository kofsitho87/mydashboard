import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blocs.dart';

class SignupApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SignupPageState();
}

class SignupPageState extends State<SignupApp> {
  final emailController = TextEditingController(text: '');
  final userNameController = TextEditingController(text: '');
  final pwController = TextEditingController(text: '');
  final rePwController = TextEditingController(text: '');

  SigninBloc signinBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var emailValid = false;
  var userNameValid = false;
  var pwValid = false;

  @override
  void initState() {
    
    signinBloc = BlocProvider.of<SigninBloc>(context);
    emailController.addListener(_onEmailChanged);
    userNameController.addListener(_onUserNameChanged);
    pwController.addListener(_onPwChanged);

    super.initState();
  }

  void _onEmailChanged(){
    setState(() {
      emailValid = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$').hasMatch(emailController.text);
    });
  }
  void _onUserNameChanged(){
    setState(() {
      //pwValid = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(pwController.text);
      userNameValid = userNameController.text.length > 2;
    });
  }
  void _onPwChanged(){
    setState(() {
      //pwValid = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(pwController.text);
      pwValid = pwController.text.length > 5;
    });
  }

  void _showErrorMsg(){
    var text = '';
    if( !emailValid ){
      text = '이메일을 입력해주세요!';
    }else if( !userNameValid ){
      text = '유저이름을 입력해주세요!';
    }else if( !pwValid ){
      text = '비밀번호를 입력해주세요!';
    }

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _signUpAction(){
    //authBloc.dispatch(SignUpEvent(emailController.text, userNameController.text, pwController.text));

    signinBloc.dispatch( AttemptSignupEvent(emailController.text, userNameController.text, pwController.text) );
  }

  Widget get _emailFormRowView {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: TextFormField(
        controller: emailController,
        //textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.white),
        keyboardAppearance: Brightness.dark,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.email, color: Colors.white),
          suffixStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          labelText: '이메일',
        ),
      ),
    );
  }

  Widget get _userNameFormRowView {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: TextFormField(
        controller: userNameController,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.white),
        keyboardAppearance: Brightness.dark,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.person, color: Colors.white),
          suffixStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          labelText: '유저네임',
        ),
      ),
    );
  }

  Widget get _passwordFormRowView {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: TextFormField(
        controller: pwController,
        obscureText: true,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.white),
        keyboardAppearance: Brightness.dark,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.security, color: Colors.white),
          suffixStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          labelText: '비밀번호',
        ),
      ),
    );
  }

  Widget get _rePasswordFormRowView {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: TextFormField(
        controller: rePwController,
        obscureText: true,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.white),
        keyboardAppearance: Brightness.dark,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.security, color: Colors.white),
          suffixStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          labelText: '비밀번호 확인',
        ),
      ),
    );
  }

  Widget get _formView {
    return Form(
      child: Column(
        children: <Widget>[
          //SizedBox(height: 100),
          _emailFormRowView,
          _userNameFormRowView,
          _passwordFormRowView,
          _rePasswordFormRowView,
          SizedBox(height: 20),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0.1,
            minWidth: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.lightGreen,
            child: Text('회원가입', style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: (emailValid && userNameValid && pwValid) ? _signUpAction : _showErrorMsg,
          ),
          SizedBox(height: 20),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0.1,
            minWidth: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Text('로그인', style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget get bodyView {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _formView,
    );
  }

  Widget get loadingView{
    return Positioned.fill(
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text('회원가입'),
      // ),
      backgroundColor: Color.fromRGBO(49, 58, 67, 1),
      body: Center(
        child: BlocBuilder(
          bloc: signinBloc,
          builder: (BuildContext context, SigninState state) {
            if( state is LoadingSignin ){
              return Stack(
                children: <Widget>[
                  bodyView,
                  loadingView
                ],
              );
            }
            
            return bodyView;
          },
        ),
      ),
    );
  }
}