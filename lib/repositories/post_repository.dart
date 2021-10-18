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

  Future<List<Post>> getPosts(String? after) {
    return reddit.getPosts(after: after);
  }
}