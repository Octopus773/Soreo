/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:soreo/models/post.dart';
import 'package:soreo/models/settings.dart';
import 'package:soreo/pages/subreddit_page.dart';
import 'package:soreo/views/video_view.dart';
import 'package:video_player/video_player.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool showSubreddit;

  const PostView({
    required this.post,
    this.showSubreddit = true,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: showSubreddit
              ? GestureDetector(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: post.subReddit.iconImage != null
                        ? NetworkImage(post.subReddit.iconImage!)
                        : const AssetImage("profile.png") as ImageProvider<Object>
                      )
                  )
                ),
                onTap: () =>
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubredditPage(subreddit: post.subReddit)
                    )
                 ),
                onLongPress: () => Fluttertoast.showToast(
                  msg: post.subReddit.title,
                  toastLength: Toast.LENGTH_SHORT
                ),
              )
              : null,
            title: Padding(
              child: Text(post.title),
              padding: const EdgeInsets.only(bottom: 20)
            ),
            subtitle: Column(
              children: [
                MarkdownBody(data: post.text ?? "???"),
                if (post.imageUrl != null)
                  Image.network(post.imageUrl!),
                if (post.videoUrl != null)
                  VideoView(
                    autoplay: context.read<Settings>().autoplay,
                    controller: VideoPlayerController.network(
                      post.videoUrl!)
                    )
              ]
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Icon(Icons.thumb_up_alt_rounded),
                onPressed: () {},
              ),
              Text((post.upVotes - post.downVotes).toString()),
              TextButton(
                child: const Icon(Icons.thumb_down_alt_rounded),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}