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
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: state.user.iconUrl != null
                                  ? NetworkImage(state.user.iconUrl!)
                                  : const AssetImage("profile.png") as ImageProvider<Object>
                              )
                            )
                          )
                        )
                      ),
                      Center(
                        child: Text(state.user.name)
                      ),
                      Center(
                        child: Text(state.user.description)
                      ),
                      Center(
                        child: ElevatedButton(
                            child: const Text("Logout"),
                            onPressed: () {
                              context.read<AuthenticationBloc>()
                                  .add(AuthenticationLogoutRequested());
                              Navigator.of(context).pop();
                            }
                        )
                      )
                    ]
                )
            )
        )
    );
  }

}