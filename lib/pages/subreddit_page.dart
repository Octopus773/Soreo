/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/posts/post_bloc.dart';
import 'package:soreo/models/subreddit.dart';
import 'package:soreo/views/subreddit_view.dart';

class SubredditPage extends StatelessWidget {
  final Subreddit subreddit;

  const SubredditPage({Key? key, required this.subreddit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (ctx) => PostBloc(
          repository: ctx.read(),
          subreddit: subreddit.fullName
        )..add(PostFetchRequestedEvent()),
        child: SubredditView(subreddit: subreddit)
    );
  }
}