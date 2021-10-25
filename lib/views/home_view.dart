/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soreo/pages/post_list_page.dart';
import 'package:soreo/pages/user_icon_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      const PostListPage(),
      const PostListPage()
    ];
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Soreo"),
              actions: const [
                UserIconPage()
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Home", icon: Icon(Icons.home)),
                  Tab(text: "Subreddit", icon: Icon(Icons.home))
                ],
              ),
            ),
            body: TabBarView(
              children: tabs,
            )
        )
    );
  }
}