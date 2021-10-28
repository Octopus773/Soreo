/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soreo/models/subreddit.dart';
import 'package:soreo/pages/subreddit_page.dart';
import 'package:soreo/services/reddit_client.dart';

import 'loading_page.dart';

class SearchPage extends StatelessWidget {
  final IRedditClient repository;

  const SearchPage({Key? key, required this.repository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<String>(
          onSearch: (query) async => query != null
            ? await repository.searchSubreddit(query)
            : [],
          placeHolder: const Center(child: Text("Type something to start searching.")),
          emptyWidget: const Text("No result found."),
          onItemFound: (String? sub, int index) {
            return ListTile(
              title: Text(sub!),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoadingPage<Subreddit>(
                    future: repository.getSubreddit(sub),
                    widget: (fullPost) => SubredditPage(subreddit: fullPost)
                  )
                ));
              },
            );
          },
        ),
      ),
    );
  }
}