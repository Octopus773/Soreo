/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/pages/user_icon_page.dart';
import 'package:soreo/repositories/authentication_repository.dart';
import 'package:soreo/repositories/reddit_factory.dart';
import 'package:soreo/repositories/user_repository.dart';
import 'package:soreo/views/post_list_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Reddit reddit = await RedditFactory().newInstance();
  final auth = AuthenticationRepository(reddit);
  final user = UserRepository(reddit: reddit);
  runApp(SoreoApp(
    auth: auth,
    user: user
  ));
}

class SoreoApp extends StatelessWidget {
  final AuthenticationRepository auth;
  final UserRepository user;

  const SoreoApp({
    Key? key,
    required this.auth,
    required this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: auth),
        RepositoryProvider.value(value: user),
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
          body: const PostListView()
        )
      )
    );
  }
}