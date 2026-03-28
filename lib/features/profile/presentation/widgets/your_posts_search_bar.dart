import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_posts_screen/your_posts_state.dart';

class YourPostsSearchBar extends StatefulWidget {
  final TextEditingController searchController;

  const YourPostsSearchBar({super.key, required this.searchController});

  @override
  State<YourPostsSearchBar> createState() => _YourPostsSearchBarState();
}

class _YourPostsSearchBarState extends State<YourPostsSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<YourPostsBloc>().add(
      YourPostsSearchChanged(query: widget.searchController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColor.veryLightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, color: AppColor.secondaryText, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: widget.searchController,
                style: AppTextStyle.bodySmall,
                decoration: InputDecoration(
                  hintText: 'Search by content...',
                  hintStyle: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.secondaryText,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            BlocBuilder<YourPostsBloc, YourPostsState>(
              builder: (context, state) {
                return state.searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () => widget.searchController.clear(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AppColor.secondaryText,
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.tune,
                          size: 20,
                          color: AppColor.secondaryText,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
