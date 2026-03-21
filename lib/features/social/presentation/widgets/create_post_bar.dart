import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/session/presentation/bloc/session_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/new_feed/new_feed_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/constants/social_text.dart';
import 'package:uit_buddy_mobile/features/social/presentation/screens/create_post_screen.dart';

class CreatePostBar extends StatelessWidget {
  const CreatePostBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.dividerGrey, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(context),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                final bloc = context.read<NewFeedBloc>();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (ctx, animation, secondaryAnimation) =>
                        BlocProvider.value(
                          value: bloc,
                          child: const CreatePostScreen(),
                        ),
                    transitionsBuilder:
                        (ctx, animation, secondaryAnimation, child) {
                          final curved = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                            reverseCurve: Curves.easeInCubic,
                          );
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(curved),
                            child: child,
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 350),
                    reverseTransitionDuration: const Duration(
                      milliseconds: 300,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.veryLightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  SocialText.createPostHint,
                  style: AppTextStyle.placeholder,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final user = context.read<SessionBloc>().state.user;
    final avatarUrl = user?.avatarUrl;
    final avatarLetter = user?.userLetterAvatar ?? 'U';

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) =>
              _buildLetterAvatar(avatarLetter),
        ),
      );
    }

    return _buildLetterAvatar(avatarLetter);
  }

  Widget _buildLetterAvatar(String letter) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColor.blueAvatarGradient,
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: AppColor.pureWhite,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
