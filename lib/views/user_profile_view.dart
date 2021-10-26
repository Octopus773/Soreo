/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/authentication/authentication_bloc.dart';

class UserProfileView extends StatelessWidget
{
  const UserProfileView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (child, state) => MaterialApp(
            title: "Soreo",
            home: Scaffold(
                appBar: AppBar(
                    title: const Text("Soreo"),
                    actions: const [
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.search)
                      ),
                    ]
                ),
                body: Column(
                    children: [
                      ElevatedButton(
                          child: const Text("Logout"),
                          onPressed: () {
                            context.read<AuthenticationBloc>()
                                .add(AuthenticationLogoutRequested());
                            Navigator.of(context).pop();
                          }
                      )
                    ]
                )
            )
        )
    );
  }

}