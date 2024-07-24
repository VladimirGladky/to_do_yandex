import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/generated/l10n.dart';
import 'package:to_do/utils/constutils.dart';

class LandscapeAppbar extends StatelessWidget {
  const LandscapeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoTasksBloc, ToDoTasksState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                S.of(context).myTasks,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).done +
                      (state is TodoTaskLoadedState
                          ? state.doneCounter.toString()
                          : " "),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                IconButton(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(0),
                  onPressed: () => context
                      .read<ToDoTasksBloc>()
                      .add(TodoTasksChangeDoneVisibilityEvent()),
                  icon: SvgPicture.asset(
                    context.read<ToDoTasksBloc>().isComplitedHide
                        ? MyIcons.kEyeIcon
                        : MyIcons.kEyeCrossIcon,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
