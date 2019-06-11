import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SigninEvent extends Equatable {
  SigninEvent([List props = const []]) : super(props);
}


class AttemptSigninEvent extends SigninEvent{
  final String email;
  final String password;

  AttemptSigninEvent(@required this.email, @required this.password) : super([email, password]);

  @override
  String toString() => 'AttemptSigninEvent';
}

class AttemptSignupEvent extends SigninEvent{
  final String email;
  final String userName;
  final String password;

  AttemptSignupEvent(@required this.email, @required this.userName, @required this.password) : super([email, userName, password]);

  @override
  String toString() => 'AttemptSignupEvent';
}

class AttemptGoogleSigninEvent extends SigninEvent{
  @override
  String toString() => 'AttemptGoogleSigninEvent';
}