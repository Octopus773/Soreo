/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart';
import 'package:flutter/services.dart';

/// A custom factory to create [Reddit] instances.
class RedditFactory {
  /// Create a new instance of [Reddit].
  Future<Reddit> newInstance() async {
    return Reddit.createInstalledFlowInstance(
        clientId: await rootBundle.loadString("assets/draw.ini"),
        userAgent: "soreo",
        redirectUri: Uri.parse("soreo://authorize")
    );
  }
}