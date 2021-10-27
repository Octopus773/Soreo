/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart' hide User, Subreddit;
import 'package:draw/draw.dart' as draw;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:soreo/models/authentication_status.dart';
import 'package:soreo/models/subreddit.dart';
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

  Future<bool> isSubscribedToSubreddit(String subreddit);
  Future subscribe(String subreddit);
  Future unsubscribe(String subreddit);
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
        description: me.data?["subreddit"]["description"] ?? "",
        iconUrl: HtmlUnescape().convert(me.data!["icon_img"] as String)
    );
  }

  Map<PostSort, Function> _getSort(String? subreddit) => subreddit == null
    ? {
      PostSort.hot: _reddit.front.hot,
      PostSort.controversial: _reddit.front.controversial,
      PostSort.news: _reddit.front.newest,
      PostSort.rising: _reddit.front.rising,
      PostSort.top: _reddit.front.top,
    }
    : {
      PostSort.hot: _reddit.subreddit(subreddit).hot,
      PostSort.controversial: _reddit.subreddit(subreddit).controversial,
      PostSort.news: _reddit.subreddit(subreddit).newest,
      PostSort.rising: _reddit.subreddit(subreddit).rising,
      PostSort.top: _reddit.subreddit(subreddit).top,
    };

  String? nullIfEmpty(String? str) => str?.isEmpty == true ? null : str;

  Subreddit convertFromReddit(draw.Subreddit sub) {
    String? banner = nullIfEmpty(sub.data?["mobile_banner_image"])
        ?? nullIfEmpty(sub.data?["banner_background_image"])
        ?? nullIfEmpty(sub.data?["banner_img"]);
    return Subreddit(
      id: sub.id,
      description: sub.data?["public_description"],
      title: sub.displayName,
      fullName: sub.displayName,
      iconImage: sub.iconImage != null ? HtmlUnescape().convert(sub.iconImage.toString()) : null,
      bannerImage: banner != null ? HtmlUnescape().convert(banner) : null,
      over18: sub.over18,
      subscriberCount: sub.data?["subscribers"],
      activeUserCount: sub.data?["active_user_count"],
    );
  }

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
    return await Future.wait(posts
      .whereType<Submission>()
      .map((event) async {
        return Post(
          id: event.fullname!,
          title: HtmlUnescape().convert(event.title),
          text:  event.selftext != null
            ? HtmlUnescape().convert(event.selftext!)
            : null,
          videoUrl: event.isVideo ? event.data!["media"]["reddit_video"]["hls_url"] : null,
          imageUrl: RegExp(r".(gif|jpe?g|bmp|png)$").hasMatch(event.url.toString())
            ? event.url.toString()
            : null,
          upVotes: event.upvotes,
          downVotes: event.downvotes,
          upVotesRatio: event.upvoteRatio,
          subReddit: convertFromReddit(await event.subreddit.populate())
        );
      })
      .toList());
  }

  @override
  Future<List<Subreddit>> getSubreddits() async {
    var ret = await _reddit.user.subreddits().toList();
    return ret.map(convertFromReddit).toList();
  }

  @override
  Future<bool> isSubscribedToSubreddit(String subreddit) async {
    if (_state == AuthenticationStatus.unauthenticated) {
      return false;
    }
    return (await getSubreddits()).any((element) => element.fullName == subreddit);
  }

  @override
  Future subscribe(String subreddit) async {
    if (_state == AuthenticationStatus.unauthenticated) {
      await login();
    }
    await _reddit.subreddit(subreddit).subscribe();
  }

  @override
  Future unsubscribe(String subreddit) async {
    if (_state == AuthenticationStatus.unauthenticated) {
      await login();
    }
    await _reddit.subreddit(subreddit).unsubscribe();
  }
}