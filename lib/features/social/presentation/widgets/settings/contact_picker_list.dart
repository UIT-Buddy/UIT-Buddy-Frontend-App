import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/chat_member_entity.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/contact_picker/contact_picker_state.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/chat_setting_text.dart';

/// Shared contact picker: search bar + selected chips row + selectable list.
/// Must be placed inside a [BlocProvider<ContactPickerBloc>] ancestor.
class ContactPickerList extends StatefulWidget {
  const ContactPickerList({super.key});

  @override
  State<ContactPickerList> createState() => _ContactPickerListState();
}

class _ContactPickerListState extends State<ContactPickerList> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactPickerBloc, ContactPickerState>(
      builder: (context, state) {
        return Column(
          children: [
            _SearchBar(
              controller: _searchController,
              onChanged: (q) => context.read<ContactPickerBloc>().add(
                ContactPickerSearchChanged(query: q),
              ),
            ),
            if (state.selectedIds.isNotEmpty) ...[
              _SelectedChipsRow(
                selected: state.allContacts
                    .where((c) => state.selectedIds.contains(c.id))
                    .toList(),
                onRemove: (id) => context.read<ContactPickerBloc>().add(
                  ContactPickerToggled(memberId: id),
                ),
              ),
              const Divider(height: 1, color: AppColor.dividerGrey),
            ],
            Expanded(
              child: state.filteredContacts.isEmpty
                  ? _EmptyState(query: state.query)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: state.filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = state.filteredContacts[index];
                        final isSelected = state.selectedIds.contains(
                          contact.id,
                        );
                        return _ContactRow(
                          contact: contact,
                          isSelected: isSelected,
                          onTap: () => context.read<ContactPickerBloc>().add(
                            ContactPickerToggled(memberId: contact.id),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Search bar
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColor.veryLightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyle.bodySmall,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: ChatSettingText.searchContactsHint,
            hintStyle: AppTextStyle.bodySmall.copyWith(
              color: AppColor.secondaryText,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColor.secondaryText,
              size: 20,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            isCollapsed: true,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Selected chips row
// ---------------------------------------------------------------------------

class _SelectedChipsRow extends StatelessWidget {
  final List<ChatMemberEntity> selected;
  final ValueChanged<String> onRemove;

  const _SelectedChipsRow({required this.selected, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.pureWhite,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ChatSettingText.selectedCount(selected.length),
            style: AppTextStyle.captionSmall.copyWith(
              color: AppColor.primaryBlue,
              fontWeight: AppTextStyle.medium,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selected
                  .map((c) => _Chip(contact: c, onRemove: onRemove))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final ChatMemberEntity contact;
  final ValueChanged<String> onRemove;

  const _Chip({required this.contact, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColor.veryLightGrey,
                backgroundImage: CachedNetworkImageProvider(contact.avatarUrl),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: GestureDetector(
                  onTap: () => onRemove(contact.id),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColor.secondaryText,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 11,
                      color: AppColor.pureWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 52,
            child: Text(
              contact.name.split(' ').first,
              style: AppTextStyle.captionSmall.copyWith(
                color: AppColor.primaryText,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Contact row
// ---------------------------------------------------------------------------

class _ContactRow extends StatelessWidget {
  final ChatMemberEntity contact;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContactRow({
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColor.veryLightGrey,
                  backgroundImage: CachedNetworkImageProvider(contact.avatarUrl),
                ),
                if (contact.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColor.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.pureWhite,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                contact.name,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.primaryText,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColor.primaryBlue : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColor.primaryBlue
                      : AppColor.dividerGrey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: AppColor.pureWhite)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  final String query;

  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColor.tertiaryText,
          ),
          const SizedBox(height: 12),
          Text(
            ChatSettingText.noContactsFound,
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
