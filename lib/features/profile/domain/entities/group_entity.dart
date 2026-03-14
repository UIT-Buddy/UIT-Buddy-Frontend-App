import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String avatarUrl;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarUrl
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    avatarUrl,
  ];
}