/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/authentication/authentication_bloc.dart';
import 'package:soreo/models/authentication_status.dart';
import 'package:soreo/pages/user_profile_page.dart';

class UserIconView extends StatelessWidget
{
  const UserIconView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (child, state) => Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              if (state.status == AuthenticationStatus.unauthenticated) {
                context.read<AuthenticationBloc>()
                  .add(AuthenticationLoginRequested());
                return;
              }
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => const UserProfilePage())
              );
            },
            child: state.user.iconUrl != null
              ? Image.network(state.user.iconUrl!)
              : const Icon(Icons.account_circle)
          )
        )
      );
  }

}