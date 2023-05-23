part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TryAutoLogin extends AuthEvent {}

// class _ForseAuthenticated extends AuthEvent {}

// class _ForseUnauthenticated extends AuthEvent {}
