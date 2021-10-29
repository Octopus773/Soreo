/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/subreddit/subreddit_bloc.dart';

class SubscribeButtonView extends StatelessWidget {
  const SubscribeButtonView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubredditBloc, SubredditState>(
        builder: (ctx, state) {
          return ElevatedButton(
            onPressed: () => context
              .read<SubredditBloc>()
              .add(
                state.status == SubredditSubscribeStatus.subscribed
                  ? SubredditUnsubscribedEvent()
                  : SubredditSubscribedEvent()
              ),
            child: state.status == SubredditSubscribeStatus.loading
              ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  )
                )
              : Text(state.status == SubredditSubscribeStatus.subscribed
                  ? "Unsubscribe"
                  : "Subscribe"
                )
          );
        }
    );
  }
}