import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/bloc/tasks_bloc/bloc/to_do_tasks_bloc.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/utils/constutils.dart';

class TaskCheckbox extends StatefulWidget {
  final String id;
  final DegreeOfImportance importance;
  final bool done;

  const TaskCheckbox(
      {super.key,
      required this.done,
      required this.id,
      required this.importance});

  @override
  State<TaskCheckbox> createState() => _TaskCheckboxState();
}

class _TaskCheckboxState extends State<TaskCheckbox> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = switch (widget.importance) {
      DegreeOfImportance.high => ColorPaletteLight.kColorRed.withOpacity(0.16),
      _ => Colors.transparent
    };
    Color borderColor = switch (widget.importance) {
      DegreeOfImportance.high => ColorPaletteLight.kColorRed,
      _ => ColorPaletteLight.kSupportSeparator.withOpacity(0.2)
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              color:
                  widget.done ? ColorPaletteLight.kColorGreen : backgroundColor,
              width: 15,
              height: 15,
            ),
            Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                checkColor: ColorPaletteLight.kColorGrayLight,
                overlayColor:
                    WidgetStateProperty.all(ColorPaletteLight.kColorGrayLight),
                fillColor: WidgetStateProperty.all(
                    widget.done ? ColorPaletteLight.kColorGreen : borderColor),
                value: widget.done,
                onChanged: (bool? newvalue) async {
                  context
                      .read<ToDoTasksBloc>()
                      .add(TodoTasksChangeDoneEvent(id: widget.id));
                })
          ],
        ),
        if (!widget.done)
          switch (widget.importance) {
            DegreeOfImportance.low => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SvgPicture.asset(MyIcons.kLowPriorityIcon)),
            DegreeOfImportance.high => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SvgPicture.asset(MyIcons.kHighPriorityIcon)),
            _ => const SizedBox()
          },
      ],
    );
  }
}
