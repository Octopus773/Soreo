/*
 * Soreo - A custom reddit client in flutter.
 *
 * Copyright (c) 2021, Zoe Roux
 */

part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

@immutable
class PostFetchRequestedEvent extends PostEvent {}
