/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/pages/search_page.dart';
import 'package:soreo/pages/user_icon_page.dart';

class AppBarView extends AppBar {
  AppBarView({Key? key})
    : super(
      key: key,
      title: const Text("Soreo"),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Builder(
              builder: (ctx) => GestureDetector(
                child: const Icon(Icons.search),
                onTap: () => Navigator.of(ctx)
                    .push(MaterialPageRoute(
                    builder: (_) => SearchPage(repository: ctx.read())
                )),
              )
          )
        ),
        const UserIconPage()
      ]
    );
}