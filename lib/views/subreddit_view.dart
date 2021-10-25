/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soreo/models/subreddit.dart';
import 'package:soreo/views/post_list_view.dart';

class SubredditView extends StatelessWidget {
  final Subreddit subreddit;

  const SubredditView({Key? key, required this.subreddit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Soreo",
        home: Scaffold(
          body: PostListView()
      )
    );
  }
}