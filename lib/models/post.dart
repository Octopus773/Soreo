/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:equatable/equatable.dart';
import 'package:soreo/models/subreddit.dart';

/// How should posts be sorted?
enum PostSort {
  hot,
  rising,
  controversial,
  news,
  best,
  top
}

/// Since when should the sort be applied?
enum PostSortSince {
  none,
  hour,
  day,
  week,
  month,
  year,
  all
}

/// A post/submission on reddit.
class Post extends Equatable {
  final String id;
  final String title;
  final String? text;
  final int upVotes;
  final int downVotes;
  final double upVotesRatio;
  final Subreddit subReddit;
  final String? videoUrl;
  final String? imageUrl;


  /// Create a new [Post].
  const Post({
    required this.id,
    required this.title,
    required this.text,
    required this.upVotes,
    required this.downVotes,
    required this.upVotesRatio,
    required this.subReddit,
    this.videoUrl,
    this.imageUrl
  });

  @override
  List<Object?> get props => [id, title, text, upVotes, downVotes, upVotesRatio, subReddit, videoUrl, imageUrl];
}