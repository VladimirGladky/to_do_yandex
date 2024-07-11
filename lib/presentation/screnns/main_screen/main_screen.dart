import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do/app/navigation/router_delegate.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/swipeable_task.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/fast_adding_task.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/sliver_appbar_delegate.dart';
import 'package:to_do/presentation/screnns/main_screen/widgets/task_element.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
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
  }
}
