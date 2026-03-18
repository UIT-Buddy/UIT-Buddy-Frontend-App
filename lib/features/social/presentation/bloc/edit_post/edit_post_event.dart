import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

abstract class EditPostEvent extends Equatable {
  const EditPostEvent();

  @override
  List<Object?> get props => [];
}

class EditPostSubmitted extends EditPostEvent {
  final PostEntity originalPost;
  final String title;
  final String? content;

  const EditPostSubmitted({
    required this.originalPost,
    required this.title,
    this.content,
  });

  @override
  List<Object?> get props => [originalPost.id, title, content];
}
