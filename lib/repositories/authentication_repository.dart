/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'dart:async';
import 'package:draw/draw.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:soreo/models/authentication_status.dart';

/// A repository to handle [AuthenticationStatus].
class AuthenticationRepository {
  final Reddit _reddit;
  final _stateStream = StreamController<AuthenticationStatus>();

  /// Create a new [AuthenticationRepository] using the given reddit instance.
  AuthenticationRepository(Reddit reddit)
    : _reddit = reddit
  {
    _stateStream.add(
        _reddit.auth.isValid
            ? AuthenticationStatus.authenticated
            : AuthenticationStatus.unauthenticated
    );
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
    print(await _reddit.user.me());
  }

  Future<void> logout() async {
    await _reddit.auth.revoke();
    _stateStream.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _stateStream.close();
  }
}