/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:soreo/models/user.dart';
import 'package:soreo/services/reddit_client.dart';

class UserRepository {
  final IRedditClient reddit;

  const UserRepository({required this.reddit});

  Future<User> getMe() async {
    User? me = await reddit.me();
    if (me == null) {
      return const User.empty();
    }
    return me;
  }
}