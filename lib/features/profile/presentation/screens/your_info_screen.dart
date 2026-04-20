import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/app/router/route_name.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_info_screen/your_info_bloc.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_info_screen/your_info_event.dart';
import 'package:uit_buddy_mobile/features/profile/presentation/bloc/your_info_screen/your_info_state.dart';

class YourInfoScreen extends StatelessWidget {
  const YourInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          serviceLocator<YourInfoBloc>()..add(const YourInfoLoaded()),
      child: const _YourInfoBody(),
    );
  }
}

class _YourInfoBody extends StatelessWidget {
  const _YourInfoBody();

  Future<void> _openEdit(BuildContext context, YourInfoEntity info) async {
    final updated = await context.push<YourInfoEntity>(
      RouteName.editYourInfo,
      extra: {'info': info, 'direction': 'forward'},
    );
    if (updated != null && context.mounted) {
      context.read<YourInfoBloc>().add(YourInfoUpdated(info: updated));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.veryLightGrey,
      body: SafeArea(
        child: BlocListener<YourInfoBloc, YourInfoState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColor.alertRed,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: BlocBuilder<YourInfoBloc, YourInfoState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
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
                            'Your Info',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.h3.copyWith(
                              fontWeight: AppTextStyle.bold,
                            ),
                          ),
                        ),
                        // Edit icon button — enabled only when data loaded
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColor.primaryText,
                            ),
                            onPressed: state.yourInfo != null
                                ? () => _openEdit(context, state.yourInfo!)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: AppColor.dividerGrey),

                  if (state.isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.errorMessage != null)
                    Expanded(
                      child: Center(
                        child: Text(
                          state.errorMessage!,
                          style: AppTextStyle.bodyMedium,
                        ),
                      ),
                    )
                  else if (state.yourInfo != null)
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _InfoSection(
                            title: 'Personal',
                            fields: [
                              _InfoField(
                                label: 'MSSV',
                                value: state.yourInfo!.mssv,
                              ),
                              _InfoField(
                                label: 'FULL NAME',
                                value: state.yourInfo!.fullName,
                              ),
                              _InfoField(
                                label: 'EMAIL',
                                value: state.yourInfo!.email,
                              ),
                              _InfoField(
                                label: 'BIO',
                                value: state.yourInfo!.bio,
                              ),
                              _InfoField(
                                label: 'FRIEND STATUS',
                                value: state.yourInfo!.friendStatus,
                              ),
                              _ImageInfoField(
                                label: 'AVATAR',
                                imageUrl: state.yourInfo!.avatarUrl,
                                width: 72,
                                height: 72,
                                borderRadius: 10,
                              ),
                              _ImageInfoField(
                                label: 'COVER PHOTO',
                                imageUrl: state.yourInfo!.coverUrl,
                                width: double.infinity,
                                height: 120,
                                borderRadius: 12,
                                fallbackAssetPath:
                                    'assets/images/placeholder/bg-placeholder-transparent.png',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _InfoSection(
                            title: 'Academic',
                            fields: [
                              _InfoField(
                                label: 'HOME CLASS CODE',
                                value: state.yourInfo!.homeClassCode,
                              ),
                              _InfoField(
                                label: 'ACCUMULATED GPA',
                                value: state.yourInfo!.accumulatedGpa
                                    .toStringAsFixed(2),
                              ),
                              _InfoField(
                                label: 'ACCUMULATED CREDITS',
                                value: '${state.yourInfo!.accumulatedCredits}',
                              ),
                              _InfoField(
                                label: 'POST COUNT',
                                value: '${state.yourInfo!.postCount}',
                              ),
                            ],
                          ),
                        ],
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

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.fields});

  final String title;
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.h4.copyWith(fontWeight: AppTextStyle.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColor.veryLightGrey,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < fields.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 1,
                    vertical: 12,
                  ),
                  child: fields[i],
                ),
                if (i < fields.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: AppColor.dividerGrey,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.captionMedium.copyWith(
            fontWeight: AppTextStyle.medium,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(value, style: AppTextStyle.bodySmall),
      ],
    );
  }
}

class _ImageInfoField extends StatelessWidget {
  const _ImageInfoField({
    required this.label,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 10,
    this.fallbackAssetPath = 'assets/images/placeholder/user-icon.png',
  });

  final String label;
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final String fallbackAssetPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.captionMedium.copyWith(
            fontWeight: AppTextStyle.medium,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: _AvatarImage(
            url: imageUrl,
            width: width,
            height: height,
            fallbackAssetPath: fallbackAssetPath,
          ),
        ),
      ],
    );
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({
    required this.url,
    required this.width,
    required this.height,
    required this.fallbackAssetPath,
  });

  final String url;
  final double width;
  final double height;
  final String fallbackAssetPath;

  bool get _isNetworkUrl =>
      url.startsWith('http://') ||
      url.startsWith('https://') ||
      url.startsWith('blob:');

  bool get _isDataUrl => url.startsWith('data:image');

  @override
  Widget build(BuildContext context) {
    if (_isDataUrl) {
      final parts = url.split(',');
      if (parts.length == 2) {
        try {
          final imageBytes = base64Decode(parts[1]);
          return Image.memory(
            imageBytes,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        } catch (_) {
          return _fallbackImage();
        }
      }
    }

    if (_isNetworkUrl) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallbackImage(),
      );
    }

    if (url.isNotEmpty) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallbackImage(),
      );
    }

    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return Image.asset(
      fallbackAssetPath,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
