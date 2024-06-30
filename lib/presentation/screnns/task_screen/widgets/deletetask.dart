import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/generated/l10n.dart';
import 'package:to_do/utils/constutils.dart';

class DeleteTask extends StatelessWidget {
  const DeleteTask({super.key, this.task});
  final TodoTask? task;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: task == null
          ? null
          : () {
              context
                  .read<ToDoTasksBloc>()
                  .add(TodoTasksRemoveEvent(id: task!.id));
              Navigator.of(context).pop();
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22),
        child: Row(
          children: [
            SvgPicture.asset(
              MyIcons.kRubbishIcon,
              colorFilter: ColorFilter.mode(
                task != null
                    ? ColorPaletteLight.kColorRed
                    : Theme.of(context).colorScheme.secondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              S.of(context).delete,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: task != null
                        ? ColorPaletteLight.kColorRed
                        : Theme.of(context).colorScheme.secondary,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
