import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../models/search_history.dart';
import 'confirm_delete_dialog.dart';

class SearchHistoryList extends StatelessWidget {
  final TextEditingController searchController;
  final Isar isar;
  final Function(String) onSearch;
  final Function() hideKeyboard;
  final Function(bool) updateShowHistory;

  const SearchHistoryList({
    Key? key,
    required this.searchController,
    required this.isar,
    required this.onSearch,
    required this.hideKeyboard,
    required this.updateShowHistory,
  }) : super(key: key);

  Future<void> _deleteSearchQuery(int id) async {
    await isar.writeTxn(() async {
      await isar.searchHistorys.delete(id);
    });
    updateShowHistory(true); 
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDeleteDialog(onConfirm: () async {
          await _deleteSearchQuery(id);
          Navigator.of(context).pop();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SearchHistory>>(
      future: isar.searchHistorys.where().findAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Sin historial de búsqueda.'));
        }

        final history = snapshot.data!;

        return Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(history[index].query),
                subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(history[index].timestamp)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context, history[index].id),
                ),
                onTap: () {
                  searchController.text = history[index].query;
                  onSearch(history[index].query);
                  hideKeyboard();
                  updateShowHistory(false);
                },
              );
            },
          ),
        );
      },
    );
  }
}
