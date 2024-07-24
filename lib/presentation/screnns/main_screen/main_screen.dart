import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do/app/navigation/router_delegate.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/landscape_appbar.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/swipeable_task.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/fast_adding_task.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/sliver_appbar_delegate.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/task_element.dart';
import 'package:to_do/utils/constutils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    if (!MyFunctions.isPortraitOrientation(context) ||
        !MyFunctions.isTablet(context)) {
      return SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ToDoTasksBloc>().add(TodoTasksLoadEvent());
            },
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(),
                  ),
                  SliverToBoxAdapter(
                    child: Card(
                      child: Column(
                        children: [
                          BlocBuilder<ToDoTasksBloc, ToDoTasksState>(
                            builder: (context, state) {
                              if (state is TodoTaskLoadedState) {
                                return ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.tasks.length,
                                  itemBuilder: (context, index) {
                                    return Swipeabletask(
                                      done: state.tasks[index].done,
                                      id: state.tasks[index].id,
                                      child: TaskElement(
                                        task: state.tasks[index],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                          const FastAddingTask(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              GetIt.I<MyRouterDelegate>().showAdd();
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Row(
              children: [
                const Expanded(flex: 1, child: LandscapeAppbar()),
                const VerticalDivider(
                  width: 1,
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: double.infinity,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<ToDoTasksBloc>().add(TodoTasksLoadEvent());
                      },
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 8.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Card(
                                elevation: 3,
                                margin: const EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    BlocBuilder<ToDoTasksBloc, ToDoTasksState>(
                                      builder: (context, state) {
                                        if (state is TodoTaskLoadedState) {
                                          return ListView.builder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: state.tasks.length,
                                            itemBuilder: (context, index) {
                                              return Swipeabletask(
                                                done: state.tasks[index].done,
                                                id: state.tasks[index].id,
                                                child: TaskElement(
                                                  task: state.tasks[index],
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(18.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const FastAddingTask(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            height: 65,
            width: 65,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  GetIt.I<MyRouterDelegate>().showAdd();
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
