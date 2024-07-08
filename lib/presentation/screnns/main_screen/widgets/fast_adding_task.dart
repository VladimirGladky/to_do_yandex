import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/generated/l10n.dart';
import 'package:uuid/uuid.dart';

class FastAddingTask extends StatefulWidget {
  const FastAddingTask({super.key});

  @override
  State<FastAddingTask> createState() => _FastAddingTaskState();
}

class _FastAddingTaskState extends State<FastAddingTask> {
  late TextEditingController _controller;
  bool iconEnabled = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15),
      child: Row(
        children: [
          IconButton(
            disabledColor: Theme.of(context).colorScheme.shadow,
            onPressed: !iconEnabled
                ? null
                : () {
                    context.read<ToDoTasksBloc>().add(
                          TodoTasksAddEvent(
                            task: TodoTask(
                                id: const Uuid().v4(),
                                text: _controller.text,
                                importance: DegreeOfImportance.none,
                                done: false,
                                createdAt: DateTime.now(),
                                changedAt: DateTime.now(),
                                lastUpdatedBy: "20062024"),
                          ),
                        );
                    _controller.clear();
                    iconEnabled = false;
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
            icon: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 17,
          ),
          Expanded(
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,
              style: Theme.of(context).textTheme.bodyMedium,
              onChanged: (value) {
                setState(() {
                  iconEnabled = _controller.text.isEmpty ? false : true;
                });
              },
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.of(context).newTask,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.shadow),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
