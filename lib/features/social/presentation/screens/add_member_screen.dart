import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/chat_member_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/contact_picker_list.dart';

class AddMemberScreen extends StatelessWidget {
  /// Current group members — their IDs are excluded from the contact list.
  final List<ChatMemberEntity> existingMembers;

  const AddMemberScreen({super.key, required this.existingMembers});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactPickerBloc()
        ..add(
          ContactPickerStarted(
            excludeIds: existingMembers.map((m) => m.id).toList(),
          ),
        ),
      child: const _AddMemberView(),
    );
  }
}

class _AddMemberView extends StatelessWidget {
  const _AddMemberView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactPickerBloc, ContactPickerState>(
      buildWhen: (prev, curr) =>
          prev.selectedIds.length != curr.selectedIds.length,
      builder: (context, state) {
        final canAdd = state.selectedIds.isNotEmpty;
        return Scaffold(
          backgroundColor: AppColor.pureWhite,
          appBar: _buildAppBar(context, canAdd, state.selectedIds.length),
          body: const ContactPickerList(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool canAdd,
    int selectedCount,
  ) {
    return AppBar(
      backgroundColor: AppColor.pureWhite,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 44,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: AppColor.primaryText,
        ),
        onPressed: () => Navigator.of(context).pop(),
        padding: const EdgeInsets.only(left: 12),
      ),
      title: Column(
        children: [
          Text(
            ChatSettingText.addMemberTitle,
            style: AppTextStyle.bodySmall.copyWith(
              fontWeight: AppTextStyle.bold,
            ),
          ),
          if (selectedCount > 0)
            Text(
              ChatSettingText.selectedCount(selectedCount),
              style: AppTextStyle.captionSmall.copyWith(
                color: AppColor.primaryBlue,
              ),
            ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextButton(
            onPressed: canAdd ? () => _onAdd(context) : null,
            child: Text(
              ChatSettingText.addAction,
              style: AppTextStyle.bodySmall.copyWith(
                color: canAdd ? AppColor.primaryBlue : AppColor.tertiaryText,
                fontWeight: AppTextStyle.medium,
              ),
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColor.dividerGrey),
      ),
    );
  }

  void _onAdd(BuildContext context) {
    // Mock: just pop back
    Navigator.of(context).pop();
  }
}
