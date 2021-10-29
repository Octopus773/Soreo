/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String description;
  final String? iconUrl;

  const User({
    required this.name,
    required this.description,
    this.iconUrl
  });

  const User.empty()
    : name = "", iconUrl = null, description = "";

  @override
  // TODO: implement props
  List<Object?> get props => [name, description, iconUrl];
}