part of 'auth_bloc.dart';

enum AuthAction { none, login, signup, logout }

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}
class AuthShowWelcomeState extends AuthState {}
class AuthUnauthenticatedState extends AuthState {}

class AuthLoadingState extends AuthState {
  final AuthAction action;
  AuthLoadingState({this.action = AuthAction.none});

  @override
  List<Object?> get props => [action];
}

class AuthAuthenticatedState extends AuthState {
  final String token;
  AuthAuthenticatedState({required this.token});
  @override
  List<Object?> get props => [token];
}

class AuthFailureState extends AuthState {
  final String message;
  AuthFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}