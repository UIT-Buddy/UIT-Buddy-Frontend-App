import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/usecases/get_groups_usecase.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/group_screen/group_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/group_screen/group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc({required GetGroupsUsecase getGroupsUsecase})
    : _getGroupsUsecase = getGroupsUsecase,
      super(const GroupState()) {
    on<GroupStarted>(_onGroupStarted);
    on<GroupSearch>(_onGroupSearch);
  }

  final GetGroupsUsecase _getGroupsUsecase;

  Future<void> _onGroupStarted(
    GroupStarted event,
    Emitter<GroupState> emit,
  ) async {
    emit(state.copyWith(status: GroupStatus.loading));

    final result = await _getGroupsUsecase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GroupStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (groupList) => emit(
        state.copyWith(
          status: GroupStatus.loaded,
          groupList: groupList,
          filteredGroupList: groupList,
        ),
      ),
    );
  }

  Future<void> _onGroupSearch(
    GroupSearch event,
    Emitter<GroupState> emit,
  ) async {
    final groupList = state.groupList ?? [];
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(state.copyWith(filteredGroupList: groupList));
    } else {
      final filtered = groupList
          .where((group) => group.name.toLowerCase().contains(query))
          .toList();
      emit(state.copyWith(filteredGroupList: filtered));
    }
  }
}
