/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef FutureWidgetBuilder<T> = Widget Function(T);

class LoadingPage<T> extends StatelessWidget {
  final Future<T> future;
  final FutureWidgetBuilder<T> widget;

  const LoadingPage({Key? key, required this.future, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (ctx, state) => state.connectionState == ConnectionState.done
        ? widget.call(state.data!)
        : const Center(child: CircularProgressIndicator())
    );
  }
}