/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Clement LE BIHAN
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/posts/post_bloc.dart';
import 'package:soreo/models/post.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(builder: (child, state) {
      switch (state.status) {
        case PostStatus.initial:
          return const Center(child: CircularProgressIndicator());
        case PostStatus.failure:
          return const Center(child: Text("Failed to fetch profile data."));
        case PostStatus.success:
          return ListView.builder(
              itemCount: state.posts.length + (state.hasReachedMax ? 0 : 1),
              controller: _scrollController,
              itemBuilder: (ctx, index) => index < state.posts.length
                  ? _ProfileView(post: state.posts[index])
                  : const Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                    ));
      }
    });
  }
}

class _ProfileView extends StatelessWidget {
  final Post post;

  const _ProfileView({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("profile page");
  }
}
