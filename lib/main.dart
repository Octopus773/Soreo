/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/pages/post_list_page.dart';
import 'package:soreo/pages/user_icon_page.dart';
import 'package:soreo/repositories/authentication_repository.dart';
import 'package:soreo/repositories/post_repository.dart';
import 'package:soreo/services/reddit_client.dart';
import 'package:soreo/repositories/user_repository.dart';

import 'blocs/authentication/authentication_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IRedditClient reddit = await RedditClient.newInstance();
  final auth = AuthenticationRepository(reddit: reddit);
  final user = UserRepository(reddit: reddit);
  final posts = PostRepository(reddit: reddit);
  runApp(SoreoApp(
    reddit: reddit,
    auth: auth,
    user: user,
    posts: posts
  ));
}

class SoreoApp extends StatelessWidget {
  final AuthenticationRepository auth;
  final UserRepository user;
  final PostRepository posts;
  final IRedditClient reddit;

  const SoreoApp({
    Key? key,
    required this.reddit,
    required this.auth,
    required this.user,
    required this.posts
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: reddit),
        RepositoryProvider.value(value: auth),
        RepositoryProvider.value(value: user),
        RepositoryProvider.value(value: posts),
      ],
      child: BlocProvider(
        create: (ctx) => AuthenticationBloc(auth: ctx.read(), user: ctx.read()),
        child: MaterialApp(
          title: "Soreo",
          home: Scaffold(
            appBar: AppBar(
              title: const Text("Soreo"),
              actions: const [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.search)
                ),
                UserIconPage()
              ]
            ),
            body: const PostListPage()
          )
        )
      )
    );
  }
}