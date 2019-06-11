import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/User.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class Autenticating extends AuthState {
  @override
  String toString() => 'Signing...';
}

class Autenticated extends AuthState {
  final User user;

  Autenticated({@required this.user}) : super([user]);

  @override
  String toString() => 'Signined';
}

class NotAutenticated extends AuthState {
  final String error;

  NotAutenticated({@required this.error}) : super([error]);

  @override
  String toString() => "Not Signined => ${error}";
}
