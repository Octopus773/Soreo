/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:soreo/models/subreddits.dart';
import 'package:soreo/services/reddit_client.dart';

part 'subreddits_event.dart';
part 'subreddits_state.dart';

class SubredditsBloc extends Bloc<SubredditsEvent, SubredditState> {
  final IRedditClient repository;
  bool _fetching = false;

  SubredditsBloc({
    required this.repository
  }) : super(const SubredditState()) {
    on<SubredditsFetchRequestEvent>((event, emit) async {
      try {
        _fetching = true;
        List<Subreddit> subreddits = await repository.getSubreddits();
        emit(state.copyWith(
            subreddits: List.of(state.subreddits)..addAll(subreddits),
            status: SubredditStatus.success,
        ));
      } catch(e) {
        print(e);
        emit(state.copyWith(status: SubredditStatus.failure));
      }
    });
  }
}
