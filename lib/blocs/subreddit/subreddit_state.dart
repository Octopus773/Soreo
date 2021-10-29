part of 'subreddit_bloc.dart';

/// Is the user subscribed to a subreddit?
enum SubredditSubscribeStatus {
  loading,
  subscribed,
  unsubscribed
}

/// A state for the [SubredditBloc].
@immutable
class SubredditState {
  final SubredditSubscribeStatus status;

  const SubredditState({required this.status});
}