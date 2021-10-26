/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:soreo/blocs/posts/post_bloc.dart';
import 'package:soreo/models/post.dart';
import 'package:soreo/pages/post_page.dart';
import 'package:soreo/pages/subreddit_page.dart';
import 'package:soreo/views/sort_button_view.dart';
import 'package:soreo/views/video_view.dart';
import 'package:video_player/video_player.dart';

class PostListView extends StatefulWidget {
  const PostListView({Key? key}) : super(key: key);

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
                    return _PostView(post: state.posts[index]);
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

class _PostView extends StatelessWidget {
  final Post post;

  const _PostView({
    required this.post,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PostPage(post: post)
            )
        ),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: GestureDetector(
                  child: const Icon(Icons.album),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubredditPage(subreddit: post.subReddit)
                    )
                  ),
                ),
                title: Text(post.title),
                subtitle: Column(
                  children: [
                    MarkdownBody(data: post.text ?? "???"),
                    if (post.imageUrl != null)
                      Image.network(post.imageUrl!),
                    if (post.videoUrl != null)
                      VideoView(
                        controller: VideoPlayerController.network(post.videoUrl!)
                      )
                  ]
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Icon(Icons.thumb_up_alt_rounded),
                    onPressed: () {/* ... */},
                  ),
                  Text((post.upVotes - post.downVotes).toString()),
                  TextButton(
                    child: const Icon(Icons.thumb_down_alt_rounded),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}