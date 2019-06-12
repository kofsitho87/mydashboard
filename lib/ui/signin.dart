import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blocs.dart';
import '../routes/index.dart';


class SigninApp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _SigninApp();
}



class _SigninApp extends State<SigninApp> {
  SigninBloc signinBloc;

  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var emailValid = false;
  var pwValid = false;

  @override
  void initState(){

    signinBloc = BlocProvider.of<SigninBloc>(context);

    //signinBloc.onError(error, stacktrace);
    

    emailController.addListener(_onEmailChanged);
    pwController.addListener(_onPwChanged);

    super.initState();
  }

  @override
  void dispose() {
    //signinBloc.dispose();

    super.dispose();
  }

  void siginInAction(){
    //authBloc.dispatch(LoginEvent(emailController.text, pwController.text));
    signinBloc.dispatch( AttemptSigninEvent(emailController.text, pwController.text) );
  }

  void googleSigninAction(){
    signinBloc.dispatch( AttemptGoogleSigninEvent() );
  }

  void _onEmailChanged(){
    setState(() {
      emailValid = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$').hasMatch(emailController.text);
    });
    //_loginFormBloc.dispatch(EmailChanged(email: emailController.text)); 
  }

  void _onPwChanged(){
    setState(() {
      //pwValid = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(pwController.text);
      pwValid = pwController.text.length > 5;
    });
    //_loginFormBloc.dispatch(PasswordChanged(password: pwController.text));
  }

  Widget get _logoView {
    return Column(
      children: <Widget>[
        Icon(Icons.dashboard, size: 80, color: Colors.lightGreen),
        SizedBox(height: 10,),
        Text('My Dashborad', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _textFormField(int type) {
    //final focus = FocusNode();
    var _labelText = type == 1 ? 'Email' : 'Password';
    var _icon = type == 1 ? Icons.email : Icons.security;

    return TextFormField(
      controller: type == 1 ? emailController : pwController,
      //focusNode: focus,
      //textInputAction: TextInputAction.next,
      obscureText: type == 2,
      autocorrect: false,
      style: TextStyle(color: Colors.white),
      keyboardAppearance: Brightness.dark,
      keyboardType: type == 1 ? TextInputType.emailAddress : TextInputType.text,
      // onFieldSubmitted: (v) {
      //   //FocusScope.of(context).requestFocus(focus);
      // },
      decoration: InputDecoration(
        //enabledBorder: const OutlineInputBorder(
          //borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        //),
        border: InputBorder.none,
        icon: Icon(_icon, color: Colors.white),
        suffixStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        //border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        labelText: _labelText,
      ),
    );
  }

  Widget _loginFormView(){
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: _textFormField(1),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: _textFormField(2),
            ),
            SizedBox(height: 20),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0.4,
              minWidth: double.infinity,
              padding: EdgeInsets.all(16),
              color: Colors.white,
              onPressed: (emailValid && pwValid) ? siginInAction : () {
                final snackBar = SnackBar(
                  content: Text('이메일과 비밀번호를 입력해주세요!'),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 1),
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
              },
              //onPressed: siginInAction,
              child: Text('로그인', 
                style: TextStyle(
                  fontSize: 20
                )
              ),
            ),
            SizedBox(height: 15),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0.1,
              minWidth: double.infinity,
              padding: EdgeInsets.all(16),
              //height: 50,
              color: Colors.lightGreen,
              onPressed: () {
                Navigator.pushNamed(context, Routes.signup);
              },
              child: Text('회원가입', 
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget get _loginFormBlocView {
  //   return BlocBuilder(
  //     bloc: _loginFormBloc,
  //     builder: (BuildContext context, LoginFormState state) {
  //       print('LoginFormState $state');
  //       return _loginFormView(state);
  //     },
  //   );
  // }

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

  Widget get socialLoginButtonsView {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              onPressed: googleSigninAction,
              minWidth: double.infinity,
              height: 60,
              color: Color.fromRGBO(220, 77, 65, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(FontAwesomeIcons.googlePlusG, color: Colors.white),
                  SizedBox(width: 15,),
                  Text('구글 로그인', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ),
          // SizedBox(width: 10),
          // Expanded(
          //   child: MaterialButton(
          //     onPressed: () => {},
          //     minWidth: double.infinity,
          //     height: 50,
          //     color: Color.fromRGBO(220, 77, 65, 1),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       mainAxisSize: MainAxisSize.max,
          //       children: <Widget>[
          //         Icon(FontAwesomeIcons.googlePlusG, color: Colors.white),
          //         SizedBox(width: 15,),
          //         Text('구글 로그인', style: TextStyle(color: Colors.white, fontSize: 20)),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget get bodyView {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _logoView,
            SizedBox(height: 50),
            _loginFormView(),
            SizedBox(height: 30),
            socialLoginButtonsView,
          ],
        ),
      ),
    );
  }

  void _showError(String message){
    final snackBar = SnackBar(
      content: Text(message), 
      backgroundColor: Colors.red
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(49, 58, 67, 1),
      body: BlocListener(
        bloc: signinBloc,
        listener: (context, state){
          if( state is FailSignin ){
            _showError(state.error);
          }
        },
        child: Center(
          child: BlocBuilder(
            bloc: signinBloc,
            builder: (BuildContext context, SigninState state) {  
              //this.context = context;
              if( state is LoadingSignin ){
                return Stack(
                  children: <Widget>[
                    bodyView,
                    loadingView
                  ],
                );
              }
              
              return bodyView;
            }
          )
        ),
      )
    );
  }
}
