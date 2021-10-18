/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String title;

  const Post({
    required this.id,
    required this.title
  });

  @override
  List<Object?> get props => [id, title];
}