import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'like_state.g.dart';

@CopyWith()
class LikeState extends Equatable {
  final List<String?> likedIds;

  const LikeState({required this.likedIds});

  @override
  List<Object?> get props => [likedIds];
}