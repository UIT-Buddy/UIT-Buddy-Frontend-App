import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uit_buddy_mobile/app/router/extensions/router_extension.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/home/presentation/constants/home_text.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _WebsiteEntry {
  const _WebsiteEntry({
    required this.title,
    required this.url,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final String title;
  final String url;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
}

final _websites = [
  _WebsiteEntry(
    title: 'Moodle Student',
    url: 'https://courses.uit.edu.vn/',
    description:
        'View your courses, tasks, deadlines and notifications from lecturers.',
    icon: Icons.school_outlined,
    iconColor: AppColor.primaryBlue,
    bgColor: AppColor.primaryBlue10,
  ),
  _WebsiteEntry(
    title: 'UIT Portal',
    url: 'https://student.uit.edu.vn/',
    description: 'Student management portal for academic records and services.',
    icon: Icons.account_balance_outlined,
    iconColor: AppColor.warningOrange,
    bgColor: AppColor.warningOrangeLight,
  ),
  _WebsiteEntry(
    title: 'Library',
    url: 'https://lib.uit.edu.vn/',
    description: 'Access the UIT digital library, e-books and research papers.',
    icon: Icons.local_library_outlined,
    iconColor: AppColor.successGreen,
    bgColor: AppColor.successGreen10,
  ),
  _WebsiteEntry(
    title: 'UIT Email',
    url: 'https://mail.google.com/a/gm.uit.edu.vn',
    description: 'Official UIT Gmail workspace for students and staff.',
    icon: Icons.email_outlined,
    iconColor: AppColor.alertRed,
    bgColor: AppColor.alertRed10,
  ),
  _WebsiteEntry(
    title: 'Scientific Research',
    url: 'https://nckh.uit.edu.vn/',
    description: 'Register and manage your scientific research projects.',
    icon: Icons.science_outlined,
    iconColor: AppColor.primaryBlueDark,
    bgColor: AppColor.primaryBlue20,
  ),
  _WebsiteEntry(
    title: 'Internship Portal',
    url: 'https://intern.uit.edu.vn/',
    description: 'Find and register for internship opportunities.',
    icon: Icons.work_outline_rounded,
    iconColor: AppColor.secondaryText,
    bgColor: AppColor.veryLightGrey,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  final _searchController = TextEditingController();
  List<_WebsiteEntry> _filtered = _websites;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _websites
          : _websites
                .where(
                  (e) =>
                      e.title.toLowerCase().contains(query) ||
                      e.url.toLowerCase().contains(query) ||
                      e.description.toLowerCase().contains(query),
                )
                .toList();
    });
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WebsiteHeader(),
            _SearchPanel(controller: _searchController),
            Expanded(
              child: _filtered.isEmpty
                  ? _EmptyState(query: _searchController.text)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _WebsiteCard(
                        entry: _filtered[index],
                        onTap: () => _open(_filtered[index].url),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _WebsiteHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => context.goBack(RouteName.home),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.primaryText,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColor.veryLightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HomeText.websiteTitle,
                style: AppTextStyle.h3.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                HomeText.websiteSubtitle,
                style: AppTextStyle.captionMedium.copyWith(
                  color: AppColor.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Search Panel ─────────────────────────────────────────────────────────────

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: controller,
        style: AppTextStyle.bodySmall,
        decoration: InputDecoration(
          hintText: HomeText.websiteSearchHint,
          hintStyle: AppTextStyle.bodySmall.copyWith(
            color: AppColor.tertiaryText,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColor.secondaryText,
            size: 20,
          ),
          filled: true,
          fillColor: AppColor.veryLightGrey,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }
}

// ─── Website Card ─────────────────────────────────────────────────────────────

class _WebsiteCard extends StatelessWidget {
  const _WebsiteCard({required this.entry, required this.onTap});

  final _WebsiteEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.dividerGrey),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: entry.bgColor,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(entry.icon, color: entry.iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          style: AppTextStyle.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryText,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 15,
                        color: AppColor.secondaryText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.url,
                    style: AppTextStyle.captionSmall.copyWith(
                      color: AppColor.primaryBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    entry.description,
                    style: AppTextStyle.captionMedium.copyWith(
                      color: AppColor.secondaryText,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

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
            'No results for "$query"',
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
