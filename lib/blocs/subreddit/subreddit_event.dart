part of 'subreddit_bloc.dart';

/// The base event for the [SubredditBloc].
@immutable
abstract class SubredditEvent {}

/// The user wants to subscribe to a subreddit.
@immutable
class SubredditSubscribedEvent extends SubredditEvent {}

/// The user wants to unsubscribe to a subreddit.
@immutable
class SubredditUnsubscribedEvent extends SubredditEvent {}
