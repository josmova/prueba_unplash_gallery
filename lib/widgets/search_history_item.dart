import 'package:flutter/material.dart';
import '../models/search_history.dart';

class SearchHistoryItem extends StatelessWidget {
  final SearchHistory history;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SearchHistoryItem({
    Key? key,
    required this.history,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(history.query),
      subtitle: Text(history.timestamp.toString()),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
