import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/bloc/tasks_bloc/bloc/to_do_tasks_bloc.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/utils/constutils.dart';

class CustomTaskScreenAppBar extends StatelessWidget {
  const CustomTaskScreenAppBar(
      {super.key,
      required this.controller,
      this.task,
      required this.chosendate,
      this.dropdownValue,
      required this.datenow});
  final TextEditingController controller;
  final TodoTask? task;
  final bool chosendate;
  final degreeofImportance? dropdownValue;
  final DateTime datenow;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close)),
          const Spacer(),
          InkWell(
            onTap: () {
              if (controller.text.isNotEmpty) {
                if (task == null) {
                  context.read<ToDoTasksBloc>().add(
                        TodoTasksAddEvent(
                          task: TodoTask(
                              id: UniqueKey().toString(),
                              text: controller.text,
                              importance:
                                  dropdownValue ?? degreeofImportance.none,
                              done: false,
                              deadline: chosendate ? datenow : null,
                              createdAt: DateTime.now(),
                              changedAt: DateTime.now(),
                              lastUpdatedBy: "22222332332"),
                        ),
                      );
                } else {
                  context.read<ToDoTasksBloc>().add(
                        TodoTasksChangeTaskEvent(
                          id: task!.id,
                          task: TodoTask(
                              id: task!.id,
                              text: controller.text,
                              importance:
                                  dropdownValue ?? degreeofImportance.none,
                              done: task!.done,
                              deadline: chosendate ? datenow : null,
                              createdAt: task!.createdAt,
                              changedAt: DateTime.now(),
                              lastUpdatedBy: "20062024"),
                        ),
                      );
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(
              "Сохранить",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: ColorPaletteLight.kColorBlue),
            ),
          ),
        ],
      ),
    );
  }
}
