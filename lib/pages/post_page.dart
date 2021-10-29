/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/posts/post_bloc.dart';
import 'package:soreo/models/post.dart';
import 'package:soreo/views/app_bar_view.dart';
import 'package:soreo/views/post_view.dart';

class PostPage extends StatelessWidget {
  final Post post;

  const PostPage({Key? key, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Soreo",
      home: Scaffold(
        appBar: AppBarView(),
        body: BlocProvider(
          create: (ctx) => PostBloc(repository: ctx.read())..add(PostFetchRequestedEvent()),
          child: SingleChildScrollView(child: PostView(post: post))
        )
      )
    );
  }
}