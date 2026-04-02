import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/app/di/app_dependencies.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/core/theme/app_text_style.dart';

import 'package:uit_buddy_mobile/features/social/domain/entities/conversation_entity.dart';

import 'package:uit_buddy_mobile/features/social/presentation/widgets/conversation_list_item.dart';
import 'package:uit_buddy_mobile/features/social/presentation/widgets/conversation_list_item_skeleton.dart';

class MessageTab extends StatelessWidget {
  const MessageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return _MessageTabView();
    
  }
}

class _MessageTabView extends StatefulWidget {
  const _MessageTabView();

  @override
  State<_MessageTabView> createState() => _MessageTabViewState();
}

class _MessageTabViewState extends State<_MessageTabView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

}
