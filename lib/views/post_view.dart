/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:soreo/models/post.dart';
import 'package:soreo/pages/subreddit_page.dart';
import 'package:soreo/views/video_view.dart';
import 'package:video_player/video_player.dart';

class PostView extends StatelessWidget {
  final Post post;

  const PostView({
    required this.post,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: GestureDetector(
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
                    builder: (_) =>
                      SubredditPage(subreddit: post.subReddit)
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