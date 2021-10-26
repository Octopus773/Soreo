part of 'subreddit_bloc.dart';

enum SubredditSubscribeStatus {
  loading,
  subscribed,
  unsubscribed
}

@immutable
class SubredditState {
  final SubredditSubscribeStatus status;

  const SubredditState({required this.status});
}