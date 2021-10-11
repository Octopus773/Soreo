/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:draw/draw.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A custom factory to create [Reddit] instances.
class RedditFactory {
  /// Create a new instance of [Reddit].
  Future<Reddit> newInstance() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? credential = await storage.read(key: "redditCredentials");
    if (credential != null) {
      return Reddit.restoreInstalledAuthenticatedInstance(
        credential,
        clientId: await rootBundle.loadString("assets/draw.ini"),
        userAgent: "soreo"
      );
    }

    return Reddit.createInstalledFlowInstance(
        clientId: await rootBundle.loadString("assets/draw.ini"),
        userAgent: "soreo",
        redirectUri: Uri.parse("soreo://authorize")
    );
  }
}