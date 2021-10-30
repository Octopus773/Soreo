/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/pages/post_list_page.dart';
import 'package:soreo/repositories/authentication_repository.dart';
import 'package:soreo/repositories/post_repository.dart';
import 'package:soreo/services/reddit_client.dart';
import 'package:soreo/repositories/user_repository.dart';
import 'package:soreo/views/app_bar_view.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'models/settings.dart';

/// The main entrypoint of the program.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IRedditClient reddit = await RedditClient.newInstance();
  final auth = AuthenticationRepository(reddit: reddit);
  final user = UserRepository(reddit: reddit);
  final posts = PostRepository(reddit: reddit);
  final settings = await reddit.getSettings();
  runApp(SoreoApp(
    reddit: reddit,
    auth: auth,
    user: user,
    posts: posts,
    settings: settings
  ));
}

/// The main widget of soreo.
class SoreoApp extends StatelessWidget {
  final AuthenticationRepository auth;
  final UserRepository user;
  final PostRepository posts;
  final IRedditClient reddit;
  final Settings settings;

  /// Create a new [SoreoApp].
  const SoreoApp({
    Key? key,
    required this.reddit,
    required this.auth,
    required this.user,
    required this.posts,
    required this.settings
  }) : super(key: key);

  /// Build the UI of Soreo.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: reddit),
        RepositoryProvider.value(value: auth),
        RepositoryProvider.value(value: user),
        RepositoryProvider.value(value: posts),
        RepositoryProvider.value(value: settings),
        RepositoryProvider.value(value: ThemeData(
          toggleableActiveColor: Color(0xFFF26875),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(0xFFF26875, {
              50: Color.fromRGBO(136,14,79, .1),
              100: Color.fromRGBO(136,14,79, .2),
              200: Color.fromRGBO(136,14,79, .3),
              300: Color.fromRGBO(136,14,79, .4),
              400: Color.fromRGBO(136,14,79, .5),
              500: Color.fromRGBO(136,14,79, .6),
              600: Color.fromRGBO(136,14,79, .7),
              700: Color.fromRGBO(136,14,79, .8),
              800: Color.fromRGBO(136,14,79, .9),
              900: Color.fromRGBO(136,14,79, 1),
            })
          )
        ))
      ],
      child: BlocProvider(
        create: (ctx) => AuthenticationBloc(auth: ctx.read(), user: ctx.read()),
        child: Builder(
          builder: (ctx) => MaterialApp(
            title: "Soreo",
            theme: ctx.read(),
            home: Scaffold(
              appBar: AppBarView(),
              body: const PostListPage()
            )
          )
        )
      )
    );
  }
}