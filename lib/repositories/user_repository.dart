/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart' hide User;
import 'package:soreo/models/user.dart';
import 'package:html_unescape/html_unescape.dart';

class UserRepository {
  final Reddit reddit;

  const UserRepository({required this.reddit});

  Future<User> getMe() async {
    Redditor? me = await reddit.user.me();
    if (me == null) {
      return const User.empty();
    }
    print(me);
    return User(
      name: me.displayName,
      iconUrl: HtmlUnescape().convert(me.data!["icon_img"] as String)
    );
  }
}