/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/posts/post_bloc.dart';
import 'package:soreo/pages/post_page.dart';
import 'package:soreo/views/post_view.dart';
import 'package:soreo/views/sort_button_view.dart';

class PostListView extends StatefulWidget {
  final bool showSubreddit;

  const PostListView({Key? key, this.showSubreddit = true}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostListView> {
  ScrollController _scrollController = ScrollController();
  bool _scrollControllerIsFromContext = false;


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    disposeScrollController();
  }

  void disposeScrollController() {
    _scrollController.removeListener(_onScroll);
    if (!_scrollControllerIsFromContext) {
      _scrollController.dispose();
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<PostBloc>().add(PostFetchRequestedEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
        builder: (child, state) {
          ScrollController? ctxScroll = PrimaryScrollController.of(context);
          if (_scrollController != ctxScroll && ctxScroll != null) {
            disposeScrollController();
            _scrollController = ctxScroll..addListener(_onScroll);
            _scrollControllerIsFromContext = true;
          }
          switch (state.status) {
            case PostStatus.initial:
              return const Center(child: CircularProgressIndicator());
            case PostStatus.failure:
              return const Center(child: Text("Failed to fetch posts."));
            case PostStatus.success:
              return ListView.builder(
                itemCount: state.posts.length + (state.hasReachedMax ? 1 : 2),
                controller: _scrollController,
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    return const SortButtonView();
                  }
                  if (index < state.posts.length) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => PostPage(post: state.posts[index])
                          )
                      ),
                      child: PostView(
                        post: state.posts[index],
                        showSubreddit: widget.showSubreddit
                      )
                    );
                  }
                  return const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    )
                  );
                }
              );
          }
      }
    );
  }
}