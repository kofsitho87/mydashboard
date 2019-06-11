import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(@required this.email, @required this.password) : super([email, password]);

  @override
  String toString() => 'LoginEvent';
}

class SignOutEvent extends AuthEvent {
  @override
  String toString() => 'SignOutEvent';
}

class CheckAuthEvent extends AuthEvent {
  @override
  String toString() => 'CheckAuthEvent';
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String userName;
  final String password;

  SignUpEvent(@required this.email, @required this.userName, @required this.password) : super([email, userName, password]);

  @override
  String toString() => 'SignUpEvent';
}

