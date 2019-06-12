import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blocs.dart';
import '../routes/index.dart';
import './signin.dart';
import './signup.dart';


// import '../resources/auth_repository.dart';
// import '../resources/file_stroage.dart';
// import 'package:path_provider/path_provider.dart';

class AuthApp extends StatelessWidget {
  final AuthBloc authBloc;
  AuthApp({@required this.authBloc});

  @override
  Widget build(BuildContext context) {
    final signinBloc = SigninBloc(authBloc: authBloc);

    return BlocProvider(
      bloc: signinBloc,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blueGrey[800],
          accentColor: Colors.lightGreen,
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.white),
            headline: TextStyle(color: Colors.white),
          ),
        ),
        initialRoute: Routes.login,
        routes: {
          Routes.login: (context) {
            return SigninApp();
          },
          Routes.signup: (context) {
            return SignupApp();
          },
        }
      )
    );
  }
}