/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'dart:async';
import 'package:draw/draw.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:soreo/models/authentication_status.dart';

/// A repository to handle [AuthenticationStatus].
class AuthenticationRepository {
  final Reddit _reddit;
  final _stateStream = StreamController<AuthenticationStatus>();

  /// Create a new [AuthenticationRepository] using the given reddit instance.
  AuthenticationRepository(Reddit reddit)
    : _reddit = reddit
  {
    AuthenticationStatus initialState;
    try {
      initialState = _reddit.auth.isValid
          ? AuthenticationStatus.authenticated
          : AuthenticationStatus.unauthenticated;
    } catch(_) {
      initialState = AuthenticationStatus.unauthenticated;
    }
    _stateStream.add(initialState);
  }

  /// An updated stream with the user's connection status.
  Stream<AuthenticationStatus> get status async*
  {
    yield *_stateStream.stream;
  }

  /// Open a login page and retrieve an authorization code. If the user
  /// has already signed in before, simply authorize the [Reddit] singleton.
  Future<void> login() async {
    final Uri url = _reddit.auth.url(["identity"], "soreo", compactLogin: true);
    final res = await FlutterWebAuth.authenticate(
        url: url.toString(),
        callbackUrlScheme: "soreo"
    );
    await _reddit.auth.authorize(Uri.parse(res).queryParameters["code"]!);
    FlutterSecureStorage storage = const FlutterSecureStorage();
    storage.write(
        key: "redditCredentials",
        value: _reddit.auth.credentials.toJson()
    );
    _stateStream.add(AuthenticationStatus.authenticated);
  }

  Future<void> logout() async {
    await _reddit.auth.revoke();
    _stateStream.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _stateStream.close();
  }
}