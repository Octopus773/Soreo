/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

class User {
  final String name;
  final String? iconUrl;

  User({
    required this.name,
    this.iconUrl
  });

  const User.empty()
    : name = "", iconUrl = null;
}