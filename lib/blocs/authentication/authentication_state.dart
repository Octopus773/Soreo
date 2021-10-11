/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final User user;

  const AuthenticationState.authenticated(this.user)
      : status = AuthenticationStatus.authenticated;

  const AuthenticationState.unauthenticated()
      : status = AuthenticationStatus.unauthenticated, user = const User.empty();

  @override
  List<Object> get props => [status, user];
}