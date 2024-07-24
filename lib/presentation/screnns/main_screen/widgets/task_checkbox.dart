import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do/app/firebase/firebase_config.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/utils/constutils.dart';

class TaskCheckbox extends StatefulWidget {
  final String id;
  final DegreeOfImportance importance;
  final bool done;
  const TaskCheckbox(
      {super.key,
      required this.id,
      required this.importance,
      required this.done});

  @override
  State<TaskCheckbox> createState() => _TodoCheckboxState();
}

class _TodoCheckboxState extends State<TaskCheckbox> {
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = switch (widget.importance) {
      DegreeOfImportance.high => GetIt.I<FirebaseAppConfig>()
          .configs
          .getRemoteConfigImportantColor()
          .withOpacity(0.16),
      _ => Colors.transparent
    };
    Color borderColor = switch (widget.importance) {
      DegreeOfImportance.high =>
        GetIt.I<FirebaseAppConfig>().configs.getRemoteConfigImportantColor(),
      _ => Theme.of(context).colorScheme.secondary.withOpacity(0.4)
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              color: widget.done ? CommonColors.kColorGreen : backgroundColor,
              width: 15.r,
              height: 15.r,
            ),
            SizedBox(
              width: 35.r,
              height: 35.r,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  checkColor: Theme.of(context).colorScheme.onSurface,
                  fillColor: WidgetStateProperty.all(
                      widget.done ? Colors.green : borderColor),
                  value: widget.done,
                  onChanged: (bool? newValue) async {
                    context
                        .read<ToDoTasksBloc>()
                        .add(TodoTasksChangeDoneEvent(id: widget.id));
                  },
                ),
              ),
            ),
          ],
        ),
        if (!widget.done)
          switch (widget.importance) {
            DegreeOfImportance.low => Padding(
                padding: const EdgeInsets.only(right: 6).r,
                child: SvgPicture.asset(MyIcons.kLowPriorityIcon)),
            DegreeOfImportance.high => Padding(
                padding: const EdgeInsets.only(right: 6).r,
                child: SvgPicture.asset(
                  MyIcons.kHighPriorityIcon,
                  colorFilter: ColorFilter.mode(
                      GetIt.I<FirebaseAppConfig>()
                          .configs
                          .getRemoteConfigImportantColor(),
                      BlendMode.srcIn),
                ),
              ),
            _ => const SizedBox()
          },
      ],
    );
  }
}
