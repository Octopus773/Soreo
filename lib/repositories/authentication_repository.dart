/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'dart:async';
import 'package:soreo/models/authentication_status.dart';
import 'package:soreo/services/reddit_client.dart';

/// A repository to handle [AuthenticationStatus].
class AuthenticationRepository {
  final IRedditClient reddit;
  final _stateStream = StreamController<AuthenticationStatus>();

  /// Create a new [AuthenticationRepository] using the given reddit instance.
  AuthenticationRepository({
    required this.reddit,
  })
  {
    _stateStream.add(reddit.status);
  }

  /// An updated stream with the user's connection status.
  Stream<AuthenticationStatus> get status async*
  {
    yield *_stateStream.stream;
  }

  /// Open a login page and retrieve an authorization code. If the user
  /// has already signed in before, simply authorize the [Reddit] singleton.
  Future<void> login() async {
    await reddit.login();
    _stateStream.add(AuthenticationStatus.authenticated);
  }

  Future<void> logout() async {
    await reddit.logout();
    _stateStream.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _stateStream.close();
  }
}