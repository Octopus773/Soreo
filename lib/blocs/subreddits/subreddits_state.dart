/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

part of 'subreddits_bloc.dart';

enum SubredditStatus { initial, success, failure }

@immutable
class SubredditState extends Equatable {
  final SubredditStatus status;
  final List<Subreddit> subreddits;

  const SubredditState({
    this.status = SubredditStatus.initial,
    this.subreddits = const <Subreddit>[],
  });

  SubredditState copyWith({
    SubredditStatus? status,
    List<Subreddit>? subreddits
  }) {
    return SubredditState(
      status: status ?? this.status,
      subreddits: subreddits ?? this.subreddits,
    );
  }

  @override
  List<Object?> get props => [status, subreddits];
}