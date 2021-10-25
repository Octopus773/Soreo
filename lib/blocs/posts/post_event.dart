/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

@immutable
class PostFetchRequestedEvent extends PostEvent {}

@immutable
class PostSortChangedEvent extends PostEvent {
  final PostSort sortBy;
  final PostSortSince sortSince;

  PostSortChangedEvent({
    this.sortBy = PostSort.hot,
    this.sortSince = PostSortSince.none,
  });
}

