part of 'post_bloc.dart';

/// Has the post been loaded and if yes successfully?
enum PostStatus { initial, success, failure }

/// The state of loaded posts.
@immutable
class PostState extends Equatable {
  /// Has the post been loaded and if yes successfully?
  final PostStatus status;
  /// The list of loaded posts.
  final List<Post> posts;
  /// Has the end of the subreddit been reached?
  final bool hasReachedMax;
  /// The sort method used.
  final PostSort sortBy;
  /// Since when the sort are sorted (all time, one week...)
  final PostSortSince sortSince;

  /// Create a new [PostState].
  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
    this.sortBy = PostSort.hot,
    this.sortSince = PostSortSince.none
  });

  /// Create a new [PostState] based on the current instance.
  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
    PostSort? sortBy,
    PostSortSince? sortSince
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      sortBy: sortBy ?? this.sortBy,
      sortSince: sortSince ?? this.sortSince
    );
  }

  @override
  List<Object?> get props => [status, posts, hasReachedMax, sortBy, sortSince];
}
