import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/bloc/tasks_bloc/bloc/to_do_tasks_bloc.dart';
import 'package:to_do/generated/l10n.dart';
import 'package:to_do/utils/constutils.dart';

class Swipeabletask extends StatefulWidget {
  const Swipeabletask({
    super.key,
    required this.id,
    required this.child,
    required this.done,
  });

  final Widget child;
  final String id;
  final bool done;

  @override
  State<Swipeabletask> createState() => _SwipeabletaskState();
}

class _SwipeabletaskState extends State<Swipeabletask> {
  double progress = 0.0;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      movementDuration: const Duration(milliseconds: 80),
      onUpdate: (details) {
        setState(() {
          progress = details.progress;
        });
      },
      key: Key(widget.id),
      background: Container(
        color: !widget.done
            ? Colors.green
            : Colors.yellow.withOpacity(1 - progress),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
                left: (MediaQuery.of(context).size.width) * progress - 47 > 10
                    ? ((MediaQuery.of(context).size.width) * progress - 47)
                    : 10),
            child: SvgPicture.asset(
              MyIcons.kDoneIcon,
              width: 15 + progress * 25 < 25 ? 15 + progress * 37 : 20,
              height: 15 + progress * 25 < 25 ? 15 + progress * 37 : 20,
            ),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(
                right: (MediaQuery.of(context).size.width) * progress - 47 > 10
                    ? ((MediaQuery.of(context).size.width) * progress - 47)
                    : 10),
            child: SvgPicture.asset(
              MyIcons.kRubbishIcon,
              width: 15 + progress * 25 < 25 ? 15 + progress * 37 : 20,
              height: 15 + progress * 25 < 25 ? 15 + progress * 37 : 20,
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          context
              .read<ToDoTasksBloc>()
              .add(TodoTasksChangeDoneEvent(id: widget.id));
          return false;
        } else {
          bool delete = true;
          final snackbarController = ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                S.of(context).delete + "?",
                style: TextStyle(color: ColorPaletteLight.kLabelPrimary),
              ),
              action: SnackBarAction(
                  textColor: ColorPaletteLight.kLabelPrimary,
                  label: S.of(context).cancel,
                  onPressed: () => delete = false),
            ),
          );
          await snackbarController.closed;
          return delete;
        }
      },
      onDismissed: (_) {
        context.read<ToDoTasksBloc>().add(TodoTasksRemoveEvent(id: widget.id));
      },
      child: widget.child,
    );
  }
}
