part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthStateLoading extends AuthState {}
