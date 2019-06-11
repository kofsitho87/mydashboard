import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';

import './bloc/blocs.dart';
import './resources/repository.dart';
import './resources/file_stroage.dart';

import 'ui/auth.dart';
import 'ui/home.dart';

//import 'ui/components/circle_progress.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBloc(
      repository: Repository(
        fileStorage: const FileStorage(
          '__flutter_bloc_app__',
          getApplicationDocumentsDirectory,
        )
      )
    );

    authBloc.dispatch(CheckAuthEvent());

    return BlocBuilder(
      bloc: authBloc,
      builder: (BuildContext context, AuthState state) {
        if(state is Autenticated) {
          return HomeApp(authBloc: authBloc);
        }else if (state is NotAutenticated){
          return AuthApp(authBloc: authBloc);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}