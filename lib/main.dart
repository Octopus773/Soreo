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
import 'package:soreo/views/post_list_view.dart';

Future<void> main() async {
  Reddit reddit = await RedditFactory().newInstance();
  final auth = AuthenticationRepository(reddit);
  runApp(SoreoApp(auth: auth));
}

class SoreoApp extends StatelessWidget {
  final AuthenticationRepository auth;

  const SoreoApp({
    Key? key,
    required this.auth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: auth)
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