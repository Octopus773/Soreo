/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soreo/models/authentication_status.dart';
import 'package:soreo/models/user.dart';
import 'package:soreo/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository auth;

  AuthenticationBloc({
    required this.auth
  })
  : super(const AuthenticationState.unauthenticated()) {
    on<AuthenticationLoginRequested>((event, emit) {
      auth.login();
    });
    on<AuthenticationLogoutRequested>((event, emit) {
      auth.logout();
    });

    on<AuthenticationStatusChanged>(_statusChanged);
    auth.status.listen((status) => add(AuthenticationStatusChanged(status)));
  }

  void _statusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit
  ) {
    switch (event.status) {
      case AuthenticationStatus.authenticated:
        break;
      case AuthenticationStatus.unauthenticated:
        emit(const AuthenticationState.unauthenticated());
    }
  }
}
