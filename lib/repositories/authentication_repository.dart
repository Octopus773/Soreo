/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import "dart:async";
import 'package:draw/draw.dart';
import 'package:flutter/services.dart';
import "package:flutter_web_auth/flutter_web_auth.dart";



/// Is the user authenticated?
enum AuthenticationState {
  /// The user is authenticated
  authenticated,

  /// The user is not authenticated
  unauthenticated
}

/// A repository to handle [AuthenticationState].
class AuthenticationRepository {
  final _stateStream = StreamController<AuthenticationState>();

  /// An updated stream with the user's connection status.
  Stream<AuthenticationState> get status async*
  {
    yield AuthenticationState.unauthenticated;
    yield *_stateStream.stream;
  }

  /// Open a login page and retrieve an authorization code. If the user
  /// has already signed in before, simply authorize the [Reddit] singleton.
  Future<void> login() async {
    final reddit = Reddit.createInstalledFlowInstance(
        clientId: await rootBundle.loadString("assets/draw.ini"),
        userAgent: "soreo",
        redirectUri: Uri.parse("soreo://authorize")
    );
    final Uri url = reddit.auth.url(["identity"], "soreo", compactLogin: true);
    print(url);
    final res = await FlutterWebAuth.authenticate(
        url: url.toString(),
        callbackUrlScheme: "soreo"
    );
    print(res);
    await reddit.auth.authorize(Uri.parse(res).queryParameters["code"]!);
    print(await reddit.user.me());
  }

  Future<void> logout() async {
    _stateStream.add(AuthenticationState.unauthenticated);
  }

  void dispose() {
    _stateStream.close();
  }
}