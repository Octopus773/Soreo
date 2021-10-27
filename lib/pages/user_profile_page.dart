/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soreo/views/user_profile_view.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UserProfileView();
  }
}