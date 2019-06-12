import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

import '../blocs.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthBloc authBloc;
  SigninBloc({@required this.authBloc});

  @override
  SigninState get initialState => NotSignin();

  @override
  Stream<SigninState> mapEventToState(
    SigninEvent event,
  ) async* {
    if(event is AttemptSigninEvent){
      yield* _mapToSigninActionToState(event.email, event.password);
    }else if (event is AttemptSignupEvent){
      yield* _mapToSignupActionToState(event.email, event.userName, event.password);
    }else if (event is AttemptGoogleSigninEvent){
      yield* _mapToGoogleSigninActionToState();
    }
  }

  Stream<SigninState> _mapToSigninActionToState(String email, String password) async* {
    try {
      yield LoadingSignin();
      //await Future.delayed(const Duration(milliseconds: 3000));
      
      await this.authBloc.repository.login(email, password);
      yield SuccessSignin();

      authBloc.dispatch( CheckAuthEvent() );
    } catch (e) {
      //yield FailSignin(error: e.toString());
      yield FailSignin(error: '로그인실패: 존재하지 않는 계정입니다.');
      //yield NotSignin();
      //throw e;
    }
  }

  Stream<SigninState> _mapToSignupActionToState(String email, String userName, String password) async* {
    try {
      yield LoadingSignin();

      await this.authBloc.repository.signUp(email, userName, password);
      yield SuccessSignup();
      yield* _mapToSigninActionToState(email, password);

    } catch (e) {
      yield FailSignup(error: '회원가입실패');
      //yield FailSignup(error: e.toString());
      //yield NotSignin();
    }
  }

  Stream<SigninState> _mapToGoogleSigninActionToState() async* {
    try {
      yield LoadingSignin();

      await this.authBloc.repository.googleSignin();
      yield SuccessSignin();

      authBloc.dispatch( CheckAuthEvent() );

    } catch (e) {
      yield FailSignin(error: e.toString());
      //yield FailSignin(error: '로그인실패: 존재하지 않는 계정입니다.');
    }
  }
}
