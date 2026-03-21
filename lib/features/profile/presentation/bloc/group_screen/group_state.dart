import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/group_entity.dart';

enum GroupStatus { initial, loading, loaded, error }

class GroupState extends Equatable {
  const GroupState({
    this.status = GroupStatus.initial,
    this.groupList,
    this.filteredGroupList,
    this.errorMessage,
  });

  final GroupStatus status;
  final List<GroupEntity>? groupList;
  final List<GroupEntity>? filteredGroupList;
  final String? errorMessage;

  GroupState copyWith({
    GroupStatus? status,
    List<GroupEntity>? groupList,
    List<GroupEntity>? filteredGroupList,
    String? errorMessage,
  }) {
    return GroupState(
      status: status ?? this.status,
      groupList: groupList ?? this.groupList,
      filteredGroupList: filteredGroupList ?? this.filteredGroupList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    groupList,
    filteredGroupList,
    errorMessage,
  ];
}
