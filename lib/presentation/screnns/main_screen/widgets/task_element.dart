import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/task_checkbox.dart';
import 'package:to_do/presentation/screnns/task_screen/task_screen.dart';
import 'package:to_do/utils/constutils.dart';

class TaskElement extends StatelessWidget {
  const TaskElement({super.key, required this.task});
  final TodoTask task;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskCheckbox(
                    done: task.done, id: task.id, importance: task.importance),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 4),
                        child: Text(
                          task.text,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: task.done
                                    ? Theme.of(context).colorScheme.secondary
                                    : null,
                                decoration: task.done
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                        ),
                      ),
                      if (task.deadline != null)
                        Text(
                          DateFormat('dd.MM.yyyy').format(task.deadline!),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: IconButton(
                      icon: SvgPicture.asset(MyIcons.kInfoOutlinedIcon),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => TaskScreen(
                                    task: task,
                                  )),
                        );
                      },
                    ))
              ],
            )));
  }
}
