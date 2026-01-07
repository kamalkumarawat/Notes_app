import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends RegisterEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends RegisterEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;

  const RegisterSubmitted({required this.email, required this.password});
}

