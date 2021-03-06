/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/authentication/authentication_bloc.dart';
import 'package:soreo/views/user_icon_view.dart';

class UserIconPage extends StatelessWidget {
  const UserIconPage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UserIconView();
  }
}