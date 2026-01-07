import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/register/state.dart';

import 'event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {

    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, error: null,isSuccess: false));

      try {
        final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email.trim(),
          password: event.password.trim(),
        );

        if (result.user != null) {
          emit(state.copyWith(isSubmitting: false, isSuccess: true));
        } else {
          emit(state.copyWith(
              isSubmitting: false, error: 'Register failed. Please try again.'));
        }
      } on FirebaseAuthException catch (e) {
        print("cdkmcfd");
        emit(state.copyWith(isSubmitting: false, error: e.message));
      } catch (e) {
        print("cdjkncbd");
        emit(state.copyWith(
            isSubmitting: false, error: 'An unexpected error occurred.'));
      }
    });
  }
}
