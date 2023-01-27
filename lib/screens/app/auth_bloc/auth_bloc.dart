import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../repositories/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepositiry) : super(AuthStateLoading()) {
    on<TryAutoLogin>(_onTryAutoLogin);
    on<_ForseAuthenticated>(_onForseAuthenticated);
    on<_ForseUnauthenticated>(_onForseUnauthenticated);

    _authStreamSubscription = _authRepositiry.authStatus().listen((authState) {
      if (authState) {
        add(_ForseAuthenticated());
      } else {
        add(_ForseUnauthenticated());
      }
    });
  }

  final AuthRepositiry _authRepositiry;
  StreamSubscription<bool>? _authStreamSubscription;

  void _onTryAutoLogin(
    TryAutoLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    await _authRepositiry.tryAutoLogin();
  }

  void _onForseAuthenticated(
    _ForseAuthenticated event,
    Emitter<AuthState> emit,
  ) async {
    emit(Authenticated());
  }

  void _onForseUnauthenticated(
    _ForseUnauthenticated event,
    Emitter<AuthState> emit,
  ) async {
    emit(Unauthenticated());
  }

  @override
  Future<void> close() {
    _authStreamSubscription!.cancel();
    return super.close();
  }
}
