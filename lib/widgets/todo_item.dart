// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
// import 'package:tudo/config/colors.dart';
import '../model/todo.dart';
// import "package:tudo/config/theme_provider.dart";

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function onToDoChanged;
  final Function onDeleteItem;

  const ToDoItem(
      {Key? key,
      required this.todo,
      required this.onToDoChanged,
      required this.onDeleteItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ListTile(
          tileColor: Theme.of(context).colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onTap: () {
            onToDoChanged(todo);
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: Icon(
              todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: Theme.of(context).colorScheme.tertiary),
          title: Text(
            todo.todoText!,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: todo.isDone ? TextDecoration.lineThrough : null),
          ),
          trailing: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.only(right: 7),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(7)),
            child: IconButton(
                onPressed: () {
                  onDeleteItem(todo.id);
                },
                color: Colors.white,
                iconSize: 18,
                icon: const Icon(Icons.delete_forever)),
          ),
        ));
  }
}
