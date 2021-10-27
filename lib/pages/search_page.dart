/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<String>(
          onSearch: (query) => Future(() => ["toto", "tata", "foo", "bar"]),
          placeHolder: const Center(child: Text("Type something to start searching.")),
          emptyWidget: const Text("No result found."),
          onItemFound: (String? post, int index) {
            return ListTile(
              title: Text(post!),
              subtitle: Text(post),
              onTap: () {
                print("yolo");
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
              },
            );
          },
        ),
      ),
    );
  }
}