/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/pages/post_list_page.dart';
import 'package:soreo/pages/user_icon_page.dart';
import 'package:soreo/repositories/authentication_repository.dart';
import 'package:soreo/repositories/post_repository.dart';
import 'package:soreo/repositories/reddit_factory.dart';
import 'package:soreo/repositories/user_repository.dart';
import 'package:tuple/tuple.dart';

import 'models/authentication_status.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Tuple2<Reddit, AuthenticationStatus> reddit = await RedditFactory()
      .newInstance();
  final auth = AuthenticationRepository(
      reddit: reddit.item1,
      initialState: reddit.item2
  );
  final user = UserRepository(reddit: reddit.item1);
  final posts = PostRepository(reddit: reddit.item1);
  runApp(SoreoApp(
    auth: auth,
    user: user,
    posts: posts
  ));
}

class SoreoApp extends StatelessWidget {
  final AuthenticationRepository auth;
  final UserRepository user;
  final PostRepository posts;

  const SoreoApp({
    Key? key,
    required this.auth,
    required this.user,
    required this.posts
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: auth),
        RepositoryProvider.value(value: user),
        RepositoryProvider.value(value: posts),
      ],
      child: MaterialApp(
        title: "Soreo",
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Soreo"),
            actions: const [
              UserIconPage()
            ]
          ),
          body: const PostListPage()
        )
      )
    );
  }
}