import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class SigninState extends Equatable {
  SigninState([List props = const []]) : super(props);
}
  
class LoadingSignin extends SigninState {
  @override
  String toString() => "LoadingSignin";
}

class NotSignin extends SigninState {
  @override
  String toString() => "NotSignin";
}

class SuccessSignin extends SigninState {
  @override
  String toString() => "SuccessSignin";
}

class FailSignin extends SigninState {
  final String error;

  FailSignin({@required this.error}) : super([error]);

  @override
  String toString() => "FailSignin => ${error}";
}

class SuccessSignup extends SigninState {
  @override
  String toString() => "SuccessSignup";
}

class FailSignup extends SigninState {
  final String error;

  FailSignup({@required this.error}) : super([error]);

  @override
  String toString() => "FailSignup => ${error}";
}