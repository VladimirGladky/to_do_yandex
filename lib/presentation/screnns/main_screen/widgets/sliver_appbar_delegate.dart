import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/generated/l10n.dart';
import 'package:to_do/utils/constutils.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  double scrollAnimationValue(double shrinkOffset) {
    double maxScrollAllowed = maxExtent - minExtent;
    return ((maxScrollAllowed - shrinkOffset) / maxScrollAllowed)
        .clamp(0, 1)
        .toDouble();
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double visibleMainHeight = max(maxExtent - shrinkOffset, minExtent);
    final double animationVal = scrollAnimationValue(shrinkOffset);
    return Container(
      height: visibleMainHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .shadow
                .withOpacity(1 - animationVal),
            blurRadius: 3.0,
            spreadRadius: 4.0,
          ),
        ],
      ),
      child: BlocBuilder<ToDoTasksBloc, ToDoTasksState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                bottom: animationVal * 18,
                left: 60,
                child: Opacity(
                  opacity: animationVal,
                  child: Text(
                    "${S.of(context).done} - ${state is TodoTaskLoadedState ? state.doneCounter.toString() : " "}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0 + animationVal * 24,
                left: (animationVal * 44 + 16).toDouble(),
                child: Text(
                  S.of(context).myTasks,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: animationVal * 12 + 20),
                ),
              ),
              Positioned(
                bottom: 5 + animationVal * 2,
                right: 25,
                child: IconButton(
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
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 150.0;
  @override
  double get minExtent => 65.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
