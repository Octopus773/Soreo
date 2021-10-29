/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:equatable/equatable.dart';

class Subreddit extends Equatable {
  final String? id;
  final String title;
  final String fullName;
  final String? description;
  final String? iconImage;
  final String? bannerImage;
  final int? subscriberCount;
  final int? activeUserCount;
  final bool over18;


  const Subreddit({
    required this.id,
    required this.title,
    required this.description,
    required this.fullName,
    required this.iconImage,
    required this.bannerImage,
    required this.subscriberCount,
    required this.activeUserCount,
    required this.over18
  });

  @override
  List<Object?> get props => [id, title, description, fullName, iconImage, bannerImage, over18, subscriberCount, activeUserCount];
}