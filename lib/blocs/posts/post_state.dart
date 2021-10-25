part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

@immutable
class PostState extends Equatable {
  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  final PostSort sortBy;
  final PostSortSince sortSince;

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
    this.sortBy = PostSort.hot,
    this.sortSince = PostSortSince.none
  });

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
