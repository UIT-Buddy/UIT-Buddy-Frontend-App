import 'package:equatable/equatable.dart';

class StorageFriendEntity extends Equatable {
  final String id;
  final String name;
  final String mssv;
  final String avatarUrl;
  final DateTime createdAt;

  const StorageFriendEntity({
    required this.id,
    required this.name,
    required this.mssv,
    required this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, mssv, avatarUrl, createdAt];
}
