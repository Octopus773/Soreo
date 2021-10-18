/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart';
import 'package:soreo/models/post.dart';

class PostRepository {
  final Reddit reddit;

  const PostRepository({
    required this.reddit
  });

  Future<List<Post>> getPosts(String? after) async {
    final posts = await reddit.front.hot(after: after, limit: 100).toList();
    return posts
        .whereType<Submission>()
        .map((event) => Post(
          id: event.fullname!,
          title: event.title,
        ))
        .toList();
  }
}