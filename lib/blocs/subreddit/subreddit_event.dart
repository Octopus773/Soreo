part of 'subreddit_bloc.dart';

@immutable
abstract class SubredditEvent {}

@immutable
class SubredditSubscribedEvent extends SubredditEvent {}

@immutable
class SubredditUnsubscribedEvent extends SubredditEvent {}
