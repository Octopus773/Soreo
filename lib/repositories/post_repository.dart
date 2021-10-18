/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:soreo/models/post.dart';
import 'package:soreo/services/reddit_client.dart';

class PostRepository {
  final IRedditClient reddit;

  const PostRepository({
    required this.reddit
  });

  Future<List<Post>> getPosts({
    String? subreddit,
    PostSort sortBy = PostSort.hot,
    PostSortSince since = PostSortSince.none,
    String? after,
    int limit = 100
  }) {
    return reddit.getPosts(
      subreddit: subreddit,
      sortBy: sortBy,
      since: since,
      after: after,
      limit: limit
    );
  }
}