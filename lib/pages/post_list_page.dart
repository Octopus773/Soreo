/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/posts/post_bloc.dart';
import 'package:soreo/views/post_list_view.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (ctx) => PostBloc(repository: ctx.read())
          ..add(PostFetchRequestedEvent()),
        child: const PostListView()
    );
  }
}