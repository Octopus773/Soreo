/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

part of 'post_bloc.dart';

/// The base event for the [PostBloc].
@immutable
abstract class PostEvent {}

/// Request that new posts should be fetched.
@immutable
class PostFetchRequestedEvent extends PostEvent {}

/// Post sorting has changed.
@immutable
class PostSortChangedEvent extends PostEvent {
  final PostSort sortBy;
  final PostSortSince sortSince;

  PostSortChangedEvent({
    this.sortBy = PostSort.hot,
    this.sortSince = PostSortSince.none,
  });
}

