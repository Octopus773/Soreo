

import 'package:soreo/models/subreddit.dart';
import 'package:soreo/services/reddit_client.dart';


import 'package:soreo/models/authentication_status.dart';
import 'package:soreo/models/settings.dart';
import 'package:soreo/models/subreddit.dart';
import 'package:soreo/models/post.dart';
import 'package:soreo/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class MockReddit extends IRedditClient
{
  AuthenticationStatus status;

  AuthenticationStatus get status;

  @override
  Future login() async {
    return throw Exception("mock class");
  }

  @override
  Future logout() async {
    return throw Exception("mock class");
  }

  @override
  Future<User?> me() async {
    return throw Exception("mock class");
  }

  @override
  Future<List<Post>> getPosts({
    String? subreddit,
    PostSort sortBy = PostSort.hot,
    PostSortSince since = PostSortSince.none,
    String? after,
    int limit = 100
  }) async {
    return throw Exception("mock class");
  }

  @override
  Future<List<Subreddit>> getSubreddits() async {
    return throw Exception("mock class");
  }

  @override
  Future<bool> isSubscribedToSubreddit(String subreddit) async {
    return throw Exception("mock class");
  }

  @override
  Future subscribe(String subreddit) async {
    return throw Exception("mock class");
  }

  @override
  Future unsubscribe(String subreddit) async {
    return throw Exception("mock class");
  }

  @override
  Future<List<String>> searchSubreddit(String query) async {
    return throw Exception("mock class");
  }

  @override
  Future<Subreddit> getSubreddit(String name) async {
    return throw Exception("mock class");
  }

  @override
  Future<Settings> getSettings() async {
    return throw Exception("mock class");
  }

  @override
  Future updateSettings(Settings settings) async {
    return throw Exception("mock class");
  }
}