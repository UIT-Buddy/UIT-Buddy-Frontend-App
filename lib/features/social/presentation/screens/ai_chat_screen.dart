import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/ai_chat/ai_chat_bloc.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/ai_chat/ai_chat_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/ai_chat/ai_chat_state.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AIChatBloc>()..add(const AIChatStarted()),
      child: const _AiChatScreenView(),
    );
  }
}

class _AiChatScreenView extends StatefulWidget {
  const _AiChatScreenView();

  @override
  State<_AiChatScreenView> createState() => _AiChatScreenViewState();
}

class _AiChatScreenViewState extends State<_AiChatScreenView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _submit(bool isSubmitting) {
    if (isSubmitting) return;
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    context.read<AIChatBloc>().add(AIChatMessageSubmitted(message: text));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AIChatBloc, AIChatState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        });
      },
      child: Scaffold(
        backgroundColor: AppColor.pureWhite,
        appBar: AppBar(
          title: Text(
            'UIT Buddy AI',
            style: AppTextStyle.h3.copyWith(fontWeight: AppTextStyle.bold),
          ),
          backgroundColor: AppColor.pureWhite,
          centerTitle: true,
          elevation: 1,
          shadowColor: AppColor.dividerGrey,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<AIChatBloc, AIChatState>(
                  builder: (context, state) {
                    if (state.status == AIChatStatus.loading &&
                        state.messages.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final msgs = state.messages;
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: msgs.length,
                      itemBuilder: (context, index) {
                        final m = msgs[index];
                        final isUser = m.isUserMessage;
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? AppColor.primaryBlue
                                  : AppColor.softGrey,
                              borderRadius: BorderRadius.circular(16).copyWith(
                                bottomRight: Radius.circular(isUser ? 0 : 16),
                                bottomLeft: Radius.circular(isUser ? 16 : 0),
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                m.message.isEmpty
                                    ? Text(
                                        '(empty message)',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: isUser
                                              ? AppColor.pureWhite
                                              : AppColor.secondaryText,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      )
                                    : MarkdownBody(
                                        data: m.message,
                                        selectable: true,
                                        styleSheet: MarkdownStyleSheet(
                                          p: AppTextStyle.bodyMedium.copyWith(
                                            color: isUser
                                                ? AppColor.pureWhite
                                                : AppColor.primaryText,
                                          ),
                                          code: AppTextStyle.bodyMedium
                                              .copyWith(
                                                color: isUser
                                                    ? AppColor.pureWhite
                                                    : AppColor.primaryText,
                                              ),
                                        ),
                                      ),
                                const SizedBox(height: 6),
                                Text(
                                  TimeOfDay.fromDateTime(
                                    m.timestamp,
                                  ).format(context),
                                  style: AppTextStyle.captionMedium.copyWith(
                                    color: AppColor.secondaryText,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<AIChatBloc, AIChatState>(
                builder: (context, state) {
                  return _buildInputBar(
                    isSubmitting: state.status == AIChatStatus.submitting,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar({required bool isSubmitting}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: AppColor.pureWhite,
        border: Border(top: BorderSide(color: AppColor.dividerGrey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !isSubmitting,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submit(isSubmitting),
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.secondaryText,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColor.dividerGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColor.dividerGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColor.primaryBlue),
                ),
                filled: true,
                fillColor: AppColor.softGrey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColor.primaryBlue,
            radius: 24,
            child: isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.pureWhite,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppColor.pureWhite,
                      size: 20,
                    ),
                    onPressed: () => _submit(isSubmitting),
                  ),
          ),
        ],
      ),
    );
  }
}
