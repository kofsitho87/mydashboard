import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class LoginFormState extends Equatable {
  final String email;
  final bool isEmailValid;
  final String password;
  final bool isPasswordValid;
  final bool formSubmittedSuccessfully;

  bool get isFormValid => isEmailValid && isPasswordValid;

  //LoginFormState([List props = const []]) : super(props);
  LoginFormState({
    @required this.email,
    @required this.isEmailValid,
    @required this.password,
    @required this.isPasswordValid,
    @required this.formSubmittedSuccessfully,
  }) : super([
    email,
    isEmailValid,
    password,
    isPasswordValid,
    formSubmittedSuccessfully,
  ]);

  // factory LoginFormState.initial() {
  //   return LoginFormState(
  //     email: '',
  //     isEmailValid: false,
  //     password: '',
  //     isPasswordValid: false,
  //     formSubmittedSuccessfully: false,
  //   );
  // }

  LoginFormState copyWith({
    String email,
    bool isEmailValid,
    String password,
    bool isPasswordValid,
    bool formSubmittedSuccessfully,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      password: password ?? this.password,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      formSubmittedSuccessfully:
          formSubmittedSuccessfully ?? this.formSubmittedSuccessfully,
    );
  }
}

class InitialLoginFormState extends LoginFormState {
  String email = '';
  bool isEmailValid = false;
  String password = '';
  bool isPasswordValid = false;
  bool formSubmittedSuccessfully = false;
}
