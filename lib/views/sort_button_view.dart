/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/posts/post_bloc.dart';
import 'package:soreo/models/post.dart';

class SortButtonView extends StatelessWidget {
  const SortButtonView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (ctx, state) {
        return ElevatedButton(
          child: Text("Sorting by ${state.sortBy.toString().split('.')[1]}"),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: PostSort.values.map((e) => ListTile(
                    title: Text("Sort by: ${e.toString().split('.')[1]}"),
                    onTap: () {
                      ctx.read<PostBloc>().add(PostSortChangedEvent(sortBy: e));
                      Navigator.pop(context);
                    }
                  )).toList()
                );
              },
            );
          },
        );
      }
    );
  }
}