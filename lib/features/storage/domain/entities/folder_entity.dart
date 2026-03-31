import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';

@immutable
class FolderEntity extends Equatable {
  final String id;
  final String name;
  final String path;
  final String parentFolderId;
  final List<SubFolderEntity> folders;
  final List<FileEntity> files;

  const FolderEntity({
    required this.id,
    required this.name,
    required this.path,
    required this.parentFolderId,
    required this.folders,
    required this.files,
  });

  FolderEntity copyWith({
    String? id,
    String? name,
    String? path,
    String? parentFolderId,
    List<SubFolderEntity>? folders,
    List<FileEntity>? files,
  }) {
    return FolderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      parentFolderId: parentFolderId ?? this.parentFolderId,
      folders: folders ?? this.folders,
      files: files ?? this.files,
    );
  }

  @override
  List<Object?> get props => [id, name, path, parentFolderId, folders, files];
}

@immutable
class SubFolderEntity extends Equatable {
  final String id;
  final String name;
  final int itemCount;

  const SubFolderEntity({
    required this.id,
    required this.name,
    required this.itemCount,
  });

  SubFolderEntity copyWith({String? id, String? name, int? itemCount}) {
    return SubFolderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  List<Object?> get props => [id, name, itemCount];
}
