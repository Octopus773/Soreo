/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

part of 'subreddits_bloc.dart';

@immutable
abstract class SubredditsEvent {}

class SubredditsFetchRequestEvent extends SubredditsEvent {}
