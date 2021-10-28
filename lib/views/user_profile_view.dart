/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soreo/blocs/authentication/authentication_bloc.dart';
import 'package:soreo/models/settings.dart';
import 'package:soreo/pages/search_page.dart';
import 'package:soreo/services/reddit_client.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key})
      : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (child, state) => MaterialApp(
            title: "Soreo",
            home: Scaffold(
                appBar: AppBar(
                    title: const Text("Soreo"),
                    actions: [
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(
                                builder: (_) => SearchPage(repository: context.read())
                              )),
                            child: const Icon(Icons.search)
                          )
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
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Autoplay video"),
                          Switch(
                            value: context.read<Settings>().autoplay,
                            onChanged: (bool value) {
                              setState(() {
                                context.read<Settings>().autoplay = value;
                                context.read<IRedditClient>().updateSettings(context.read<Settings>());
                              });
                            }
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Display NSFW"),
                          Switch(
                            value: context.read<Settings>().displayNsfw,
                            onChanged: (bool value) {
                              setState(() {
                                context.read<Settings>().displayNsfw = value;
                                context.read<IRedditClient>().updateSettings(context.read<Settings>());
                              });
                            }
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Email on post reply"),
                          Switch(
                            value: context.read<Settings>().emailOnReply,
                            onChanged: (bool value) {
                              setState(() {
                                context.read<Settings>().emailOnReply = value;
                                context.read<IRedditClient>().updateSettings(context.read<Settings>());
                              });
                            }
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Email on upvote"),
                          Switch(
                            value: context.read<Settings>().emailOnUpvote,
                            onChanged: (bool value) {
                              setState(() {
                                context.read<Settings>().emailOnUpvote = value;
                                context.read<IRedditClient>().updateSettings(context.read<Settings>());
                              });
                            }
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Email on new follow"),
                          Switch(
                            value: context.read<Settings>().emailOnFollow,
                            onChanged: (bool value) {
                              setState(() {
                                context.read<Settings>().emailOnFollow = value;
                                context.read<IRedditClient>().updateSettings(context.read<Settings>());
                              });
                            }
                          )
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Email on mention"),
                          Switch(
                            value: context.read<Settings>().emailOnMention,
                            onChanged: (bool value) {
                              setState(() {
                                context.read<Settings>().emailOnMention = value;
                                context.read<IRedditClient>().updateSettings(context.read<Settings>());
                              });
                            }
                          )
                        ]
                      ),
                    ]
                )
            )
        )
    );
  }
}