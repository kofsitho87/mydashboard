import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import './bloc.dart';

import '../../resources/repository.dart';
//import '../../resources/file_stroage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Repository repository;

  AuthBloc({@required this.repository});

  @override
  AuthState get initialState => NotAutenticated(error: 'INIT_STATE');

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    
    if (event is LoginEvent) {
      yield* _LoginAction(event.email, event.password);
    }
    else if (event is CheckAuthEvent) {
      yield* _CheckAuthAction();
    }else if (event is SignOutEvent) {
      yield* _SignOutAction();
    }else if (event is SignUpEvent) {
      yield* _SignUpAction(event);
    }
  }

  Stream<AuthState> _LoginAction(String email, String password) async* {
    try {
      yield Autenticating();

      final user = await this.repository.login(email, password);
      yield Autenticated(user: user);
    } catch (e) {
      yield NotAutenticated(error: e.toString());
    }
  }

  Stream<AuthState> _CheckAuthAction() async* {
    try {
      yield Autenticating();
      final user = await this.repository.loadUser();
      yield Autenticated(user: user);
    } catch (e) {
      yield NotAutenticated(error: e.toString());
    }
  }

  Stream<AuthState> _SignOutAction() async* {
    try {
      yield Autenticating();
      final result = await this.repository.signOut();
      yield NotAutenticated(error: 'SignOut');
    } catch (e) {
      yield NotAutenticated(error: e.toString());
    }
  }

  Stream<AuthState> _SignUpAction(SignUpEvent event) async* {
    try {
      yield Autenticating();
      final user = await this.repository.signUp(event.email, event.userName, event.password);
      
      print('sign up result is => $user');

      yield* _LoginAction(event.email, event.password);

    } catch (e) {
      yield NotAutenticated(error: e.toString());
    }
  }
}
