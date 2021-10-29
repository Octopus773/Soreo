/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

class Settings {
  bool autoplay;
  bool displayNsfw;
  bool emailOnReply;
  bool emailOnUpvote;
  bool emailOnFollow;
  bool emailOnMention;

  Settings({
    required this.autoplay,
    required this.displayNsfw,
    required this.emailOnReply,
    required this.emailOnUpvote,
    required this.emailOnFollow,
    required this.emailOnMention,
  });
}