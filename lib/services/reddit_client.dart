/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart' hide User;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:soreo/models/authentication_status.dart';
import 'package:soreo/models/post.dart';
import 'package:soreo/models/user.dart';
import 'package:uuid/uuid.dart';


abstract class IRedditClient {
  Future login();

  Future logout();

  AuthenticationStatus get status;

  Future<User?> me();

  Future<List<Post>> getPosts({
    String? after
  });
}


class RedditClient extends IRedditClient {
  late Reddit _reddit;
  late AuthenticationStatus _state;

  RedditClient._();

  static Future<RedditClient> newInstance() async{
    final client = RedditClient._();

    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? credential = await storage.read(key: "redditCredentials");
    if (credential == null) {
      await client._useReadOnlyClient();
      return client;
    }
    client._reddit = Reddit.restoreInstalledAuthenticatedInstance(
      credential,
      clientId: await rootBundle.loadString("assets/draw.ini"),
      userAgent: "soreo"
    );
    client._state = AuthenticationStatus.authenticated;
    return client;
  }

  Future _useReadOnlyClient() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? id = await storage.read(key: "deviceID");
    if (id == null) {
      id = const Uuid().v4();
      await storage.write(key: "deviceId", value: id);
    }
    _reddit = await Reddit.createUntrustedReadOnlyInstance(
        clientId: await rootBundle.loadString("assets/draw.ini"),
        deviceId: id,
        userAgent: "soreo"
    );
    _state = AuthenticationStatus.unauthenticated;
  }

  @override
  Future login() async {
    _reddit = Reddit.createInstalledFlowInstance(
        clientId: await rootBundle.loadString("assets/draw.ini"),
        userAgent: "soreo",
        redirectUri: Uri.parse("soreo://authorize")
    );
    final Uri url = _reddit.auth.url(["*"], "soreo", compactLogin: true);
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
    _state = AuthenticationStatus.authenticated;
  }

  @override
  Future logout() async {
    try {
      await _reddit.auth.revoke();
    } catch(_) {}
    FlutterSecureStorage storage = const FlutterSecureStorage();
    storage.delete(key: "redditCredentials");
    _useReadOnlyClient();
  }

  @override
  AuthenticationStatus get status => _state;

  @override
  Future<User?> me() async {
    Redditor? me = await _reddit.user.me();
    if (me == null) {
      return null;
    }
    return User(
        name: me.displayName,
        iconUrl: HtmlUnescape().convert(me.data!["icon_img"] as String)
    );
  }

  @override
  Future<List<Post>> getPosts({
    String? after
  }) async {
    final posts = await _reddit.front.hot(after: after, limit: 100).toList();
    return posts
        .whereType<Submission>()
        .map((event) => Post(
          id: event.fullname!,
          title: event.title,
        ))
        .toList();
  }
}