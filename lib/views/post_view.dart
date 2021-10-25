/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soreo/models/post.dart';

class PostView extends StatelessWidget {
  final Post post;

  const PostView({Key? key, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(post.title);
  }
}