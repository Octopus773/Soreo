/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

part of 'authentication_bloc.dart';

/// The base event for the [AuthenticationBloc].
abstract class AuthenticationEvent extends Equatable {
  /// Create an empty [AuthenticationEvent]
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

/// The status of the user has changed. This occurs after a login/logout.
class AuthenticationStatusChanged extends AuthenticationEvent {
  /// The authentication status of the current instance.
  final AuthenticationStatus status;

  /// Create a new [AuthenticationStatusChanged].
  const AuthenticationStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}

/// Someone wants to login.
class AuthenticationLoginRequested extends AuthenticationEvent {}

/// Someone wants to logout.
class AuthenticationLogoutRequested extends AuthenticationEvent {}