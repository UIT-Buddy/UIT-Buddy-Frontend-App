import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/settings/contact_picker_list.dart';

class CreateGroupScreen extends StatelessWidget {
  /// The 1:1 conversation we're converting into a group.
  /// The partner will be pre-selected in the picker.
  final ConversationEntity sourceConversation;

  const CreateGroupScreen({super.key, required this.sourceConversation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactPickerBloc()
        ..add(const ContactPickerStarted())
        // Pre-select the 1:1 partner right after load
        ..add(ContactPickerToggled(memberId: sourceConversation.id)),
      child: _CreateGroupView(sourceConversation: sourceConversation),
    );
  }
}

class _CreateGroupView extends StatefulWidget {
  final ConversationEntity sourceConversation;

  const _CreateGroupView({required this.sourceConversation});

  @override
  State<_CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<_CreateGroupView> {
  final _nameController = TextEditingController();
  bool _hasName = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      final hasName = _nameController.text.trim().isNotEmpty;
      if (hasName != _hasName) setState(() => _hasName = hasName);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactPickerBloc, ContactPickerState>(
      buildWhen: (prev, curr) =>
          prev.selectedIds.length != curr.selectedIds.length,
      builder: (context, state) {
        final canCreate = _hasName && state.selectedIds.isNotEmpty;
        return Scaffold(
          backgroundColor: AppColor.pureWhite,
          appBar: _buildAppBar(context, canCreate),
          body: Column(
            children: [
              _GroupNameInput(controller: _nameController),
              const Divider(height: 1, color: AppColor.dividerGrey),
              const Expanded(child: ContactPickerList()),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool canCreate) {
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
      title: Text(
        ChatSettingText.createGroupTitle,
        style: AppTextStyle.bodySmall.copyWith(fontWeight: AppTextStyle.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextButton(
            onPressed: canCreate ? () => _onCreate(context) : null,
            child: Text(
              ChatSettingText.createAction,
              style: AppTextStyle.bodySmall.copyWith(
                color: canCreate ? AppColor.primaryBlue : AppColor.tertiaryText,
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

  void _onCreate(BuildContext context) {
    // Mock: just pop back
    Navigator.of(context).pop();
  }
}

// ---------------------------------------------------------------------------
// Group name input
// ---------------------------------------------------------------------------

class _GroupNameInput extends StatelessWidget {
  final TextEditingController controller;

  const _GroupNameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.primaryBlue10,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: AppColor.primaryBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              style: AppTextStyle.bodySmall,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: ChatSettingText.groupNameHint,
                hintStyle: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.secondaryText,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                filled: true,
                fillColor: AppColor.veryLightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColor.primaryBlue,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
