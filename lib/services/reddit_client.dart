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
    String? subreddit,
    PostSort sortBy = PostSort.hot,
    PostSortSince since = PostSortSince.none,
    String? after,
    int limit = 100
  });

  Future<List<Subreddit>> getSubreddits();
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

  Map<PostSort, Function> _getSort(String? subreddit) => subreddit == null
    ? {
      PostSort.hot: _reddit.front.hot,
      PostSort.controversial: _reddit.front.controversial,
      PostSort.news: _reddit.front.newest,
      PostSort.random: _reddit.front.randomRising,
      PostSort.rising: _reddit.front.rising,
      PostSort.top: _reddit.front.top,
    }
    : {
      PostSort.hot: _reddit.subreddit(subreddit).hot,
      PostSort.controversial: _reddit.subreddit(subreddit).controversial,
      PostSort.news: _reddit.subreddit(subreddit).newest,
      PostSort.random: _reddit.subreddit(subreddit).randomRising,
      PostSort.rising: _reddit.subreddit(subreddit).rising,
      PostSort.top: _reddit.subreddit(subreddit).top,
    };

  @override
  Future<List<Post>> getPosts({
    String? subreddit,
    PostSort sortBy = PostSort.hot,
    PostSortSince since = PostSortSince.none,
    String? after,
    int limit = 100
  }) async {
    List<UserContent> posts = await Function.apply(_getSort(subreddit)[sortBy]!, [], {
      #after: after,
      #limit: limit
    }).toList();
    return posts
        .whereType<Submission>()
        .map((event) => Post(
          id: event.fullname!,
          title: event.title,
          text: event.selftext,
          upVotes: event.upvotes,
          downVotes: event.downvotes,
          upVotesRatio: event.upvoteRatio
        ))
        .toList();
  }

  @override
  Future<List<Subreddit>> getSubreddits() async {
    var ret = await _reddit.user.subreddits().toList();
    return ret.map((e) => Subreddit(
        id: e.id,
        title: e.title
    )).toList();
  }
}