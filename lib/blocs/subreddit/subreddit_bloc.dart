
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:soreo/services/reddit_client.dart';

part 'subreddit_event.dart';
part 'subreddit_state.dart';

/// The [Bloc] used to register and unsubscribe to subreddits.
class SubredditBloc extends Bloc<SubredditEvent, SubredditState> {
  final IRedditClient repository;
  final String subreddit;

  /// Create a new [SubredditBloc].
  SubredditBloc({
    required this.subreddit,
    required this.repository
  }) : super(const SubredditState(status: SubredditSubscribeStatus.loading)) {
    on<SubredditSubscribedEvent>((event, emit) async {
      await repository.subscribe(subreddit);
      emit(const SubredditState(status: SubredditSubscribeStatus.subscribed));
    });
    on<SubredditUnsubscribedEvent>((event, emit) async {
      await repository.unsubscribe(subreddit);
      emit(const SubredditState(status: SubredditSubscribeStatus.unsubscribed));
    });
    repository.isSubscribedToSubreddit(subreddit).then((x) {
      emit(SubredditState(status: x
        ? SubredditSubscribeStatus.subscribed
        : SubredditSubscribeStatus.unsubscribed)
      );
    });
  }
}
