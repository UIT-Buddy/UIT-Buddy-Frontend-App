import 'package:flutter/material.dart';


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
