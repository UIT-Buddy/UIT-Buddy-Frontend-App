import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/group_screen/group_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/group_screen/group_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/group_screen/group_state.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/group_item_widget.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<GroupBloc>().add(GroupSearch(query));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<GroupBloc>()..add(const GroupStarted()),
      child: Scaffold(
        backgroundColor: AppColor.veryLightGrey,
        body: SafeArea(
          child: BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              if (state.status == GroupStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Something went wrong.',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }

              final isLoading =
                  state.status == GroupStatus.initial ||
                  state.status == GroupStatus.loading;
              final groupList = state.filteredGroupList ?? [];

              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColor.primaryText,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Text(
                            'Groups Joined',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.h3.copyWith(
                              fontWeight: AppTextStyle.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search by name...',
                        hintStyle: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.secondaryText,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColor.secondaryText,
                          size: 20,
                        ),
                        suffixIcon: const Icon(
                          Icons.tune,
                          color: AppColor.secondaryText,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: AppColor.pureWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColor.dividerGrey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColor.dividerGrey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColor.primaryBlue,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Group count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${groupList.length} ${groupList.length == 1 ? 'group' : 'groups'}',
                        style: AppTextStyle.bodySmall.copyWith(
                          fontWeight: AppTextStyle.bold,
                          color: AppColor.primaryText,
                        ),
                      ),
                    ),
                  ),

                  // Groups list
                  if (isLoading)
                    Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (groupList.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'You have not joined any groups yet.'
                              : 'No groups found.',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.secondaryText,
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: groupList.length,
                        itemBuilder: (context, index) {
                          final group = groupList[index];
                          return GroupItemWidget(
                            group: group,
                            onJoinChat: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Joined ${group.name} chat'),
                                ),
                              );
                            },
                            onViewMembers: () {},
                            onLeaveGroup: () {},
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
