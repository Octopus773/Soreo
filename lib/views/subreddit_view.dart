/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/subreddit/subreddit_bloc.dart';
import 'package:soreo/models/subreddit.dart';
import 'package:soreo/views/post_list_view.dart';
import 'package:soreo/views/subscribe_button_view.dart';

class SubredditView extends StatelessWidget {
  final Subreddit subreddit;

  const SubredditView({Key? key, required this.subreddit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubredditBloc(
        subreddit: subreddit.fullName,
        repository: context.read()
      ),
      child:
        MaterialApp(
          title: "Soreo",
          home: Scaffold(
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Text("r/${subreddit.fullName} - Soreo"),
                    expandedHeight: 275.0,
                    pinned: true,
                    floating: false,
                    forceElevated: innerBoxIsScrolled,
                    flexibleSpace:
                      FlexibleSpaceBar(
                        background: Column(
                          children: [
                            if (subreddit.bannerImage != null && subreddit.bannerImage!.isNotEmpty)
                              Image.network(subreddit.bannerImage!, fit: BoxFit.cover, height: 200, width: double.infinity)
                            else
                              const SizedBox(height: 200),
                            Text(subreddit.description ?? ""),
                            Text("${subreddit.subscriberCount} members - ${subreddit.activeUserCount} online"),
                            const SubscribeButtonView()
                          ]
                        )
                      ),
                    // actions: const [
                    //   UserIconPage()
                    // ],
                  ),
                ];
              },
              body: const PostListView()
          )
          )
        )
    );
  }
}