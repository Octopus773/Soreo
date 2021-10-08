/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart' hide User;
import 'package:soreo/models/user.dart';

class UserRepository {
  final Reddit reddit;

  const UserRepository({required this.reddit});

  Future<User> getMe() async {
    Redditor? me = await reddit.user.me();
    return const User();
  }
}