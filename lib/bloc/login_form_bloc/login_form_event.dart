import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginFormEvent extends Equatable {
  LoginFormEvent([List props = const []]) : super(props);
}

class EmailChanged extends LoginFormEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class PasswordChanged extends LoginFormEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class FormSubmitted extends LoginFormEvent {
  @override
  String toString() => 'FormSubmitted';
}

class FormReset extends LoginFormEvent {
  @override
  String toString() => 'FormReset';
}
