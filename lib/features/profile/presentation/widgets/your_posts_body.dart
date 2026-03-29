import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/your_posts_header.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/your_posts_search_bar.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/widgets/your_posts_list.dart';

class YourPostsBody extends StatefulWidget {
  const YourPostsBody({super.key});

  @override
  State<YourPostsBody> createState() => _YourPostsBodyState();
}

class _YourPostsBodyState extends State<YourPostsBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            const YourPostsHeader(),
            const Divider(height: 1, color: AppColor.dividerGrey),
            YourPostsSearchBar(searchController: _searchController),
            const Expanded(child: YourPostsList()),
          ],
        ),
      ),
    );
  }
}
