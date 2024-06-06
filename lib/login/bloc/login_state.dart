import 'package:agora/login/domain/login_error_type.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginErrorState extends LoginState {
  final LoginErrorType errorType;

  LoginErrorState({required this.errorType});

  @override
  List<Object> get props => [errorType];
}
