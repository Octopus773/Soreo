/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

part of 'authentication_bloc.dart';

/// The authentication state.
class AuthenticationState extends Equatable {
  /// Is the user logged in?
  final AuthenticationStatus status;
  /// The user if someone is logged in, [User.empty] otherwise.
  final User user;

  /// Create a new [AuthenticationState] for an authenticated user.
  const AuthenticationState.authenticated(this.user)
      : status = AuthenticationStatus.authenticated;

  /// Create a new [AuthenticationState] but no user is logged in.
  const AuthenticationState.unauthenticated()
      : status = AuthenticationStatus.unauthenticated, user = const User.empty();

  @override
  List<Object> get props => [status, user];
}