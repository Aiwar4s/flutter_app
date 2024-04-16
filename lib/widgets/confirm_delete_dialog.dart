import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final String type; // e.g. Trip, Rating, etc.

  const ConfirmDeleteDialog({super.key, required this.onDelete, required this.type});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: Text('Are you sure you want to delete this $type?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: onDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}