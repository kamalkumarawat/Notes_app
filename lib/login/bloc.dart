import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/login/state.dart';

import 'event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, error: null, isSuccess: false));

      try {
        final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password.trim(),
        );

        if (result.user != null) {
          emit(state.copyWith(isSubmitting: false, isSuccess: true));
        } else {
          emit(state.copyWith(
              isSubmitting: false, error: 'Login failed. Please try again.'));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isSubmitting: false, error: e.message));
      } catch (e) {
        emit(state.copyWith(
            isSubmitting: false, error: 'An unexpected error occurred.'));
      }
    });
  }
}
