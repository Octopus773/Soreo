/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:equatable/equatable.dart';
import 'package:soreo/models/subreddit.dart';

enum PostSort {
  hot,
  random,
  rising,
  controversial,
  news,
  best,
  top
}

enum PostSortSince {
  none,
  hour,
  day,
  week,
  month,
  year,
  all
}

class Post extends Equatable {
  final String id;
  final String title;
  final String? text;
  final int upVotes;
  final int downVotes;
  final double upVotesRatio;
  final Subreddit subReddit;


  const Post({
    required this.id,
    required this.title,
    required this.text,
    required this.upVotes,
    required this.downVotes,
    required this.upVotesRatio,
    required this.subReddit
  });

  @override
  List<Object?> get props => [id, title, text, upVotes, downVotes, upVotesRatio, subReddit];
}