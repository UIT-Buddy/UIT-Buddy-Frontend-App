import 'package:flutter/material.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportGradeGuideScreen extends StatelessWidget {
  const ImportGradeGuideScreen({super.key});

  static const _sectionDivider = Divider(
    height: 1,
    thickness: 1,
    color: AppColor.dividerGrey,
  );

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.primaryText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Import Grade Guide',
              textAlign: TextAlign.center,
              style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                _sectionDivider,
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        "IMPORTANT: Make sure you're on a desktop device during the first several steps!",
                        style: AppTextStyle.bodyLarge.copyWith(
                          fontWeight: AppTextStyle.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        children: [
                          Text(
                            "Step 1: open your browser and go to ",
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.secondaryText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.tryParse(
                                "https://daa.uit.edu.vn/",
                              );
                              await launchUrl(
                                uri!,
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(
                              "https://daa.uit.edu.vn/",
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColor.primaryBlue,
                                fontWeight: AppTextStyle.bold,
                              ),
                            ),
                          ),
                          Text(
                            " or ",
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.secondaryText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.tryParse(
                                "https://student.uit.edu.vn/",
                              );
                              await launchUrl(
                                uri!,
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(
                              "https://student.uit.edu.vn/",
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColor.primaryBlue,
                                fontWeight: AppTextStyle.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Image.asset('assets/images/guide/grade/1.png'),
                      const SizedBox(height: 12),
                      Text(
                        "Step 2: log in with your student account",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/images/guide/grade/2.png'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step 3: hover over the 'Sinh viên' section, then 'Tra cứu', then click on 'Kết quả học tập'",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/images/guide/grade/3.png'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step 4: click on the 'In bảng điểm' button",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/images/guide/grade/4.png'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step 5: on the grade screen, hit ctrl + P (or cmd + P on Mac) to open the print dialog",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/images/guide/grade/5.png'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step 6: in the 'Destination' section, select 'Save as PDF', then click the 'Save' button.",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/images/guide/grade/6.png'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step 7: move your saved transcript PDF file to your mobile device. You can do this in a variety of ways.",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step 8: Open UIT Buddy, go to the Academic Detail screen, and tap the 'Import grades' button. Then select the PDF file you just transferred to your device.",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
