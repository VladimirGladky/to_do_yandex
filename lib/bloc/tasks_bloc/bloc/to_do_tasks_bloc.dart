import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:logger/logger.dart';

part 'to_do_tasks_event.dart';
part 'to_do_tasks_state.dart';

class ToDoTasksBloc extends Bloc<ToDoTasksEvent, ToDoTasksState> {
  List<TodoTask> resultList = [];
  List<TodoTask> tasks = todoTasks;
  int doneCounter = 0;
  var logger = Logger();
  bool isComplitedHide = false;

  ToDoTasksBloc() : super(ToDoTasksInitial()) {
    on<TodoTasksLoadEvent>(_onTasksLoadEvent);
    on<TodoTasksChangeDoneEvent>(_onTasksChangeDoneEvent);
    on<TodoTasksRemoveEvent>(_onTasksRemoveEvent);
    on<TodoTasksAddEvent>(_onTodoTasksAddEvent);
    on<TodoTasksChangeDoneVisibilityEvent>(
        _onTodoTasksChangeDoneVisibilityEvent);
    on<TodoTasksChangeTaskEvent>(_onTodoTasksChangeTaskEvent);
  }

  FutureOr<void> _onTasksLoadEvent(
      TodoTasksLoadEvent event, Emitter<ToDoTasksState> emit) {
    logger.log(Level.trace, "Start load task event");
    emit(TodoTaskLoadingState());
    _filterFunction();
    logger.log(Level.trace, "End load task event\nResult list: $resultList");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  FutureOr<void> _onTasksChangeDoneEvent(
      TodoTasksChangeDoneEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(
        Level.trace, "Start Change Done event for task with ${event.id} id");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter + 1));
    tasks.firstWhere((element) => element.id == event.id).done =
        !tasks.firstWhere((element) => element.id == event.id).done;
    emit(TodoTaskLoadingState());
    _filterFunction();
    logger.log(
        Level.trace, "End Change Done event for task with ${event.id} id");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  FutureOr<void> _onTasksRemoveEvent(
      TodoTasksRemoveEvent event, Emitter<ToDoTasksState> emit) {
    logger.log(Level.trace, "Start Remove event for task with ${event.id} id");
    emit(TodoTaskLoadingState());
    tasks.removeWhere((element) => element.id == event.id);
    _filterFunction();
    logger.log(Level.trace, "End Remove event for task with ${event.id} id");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  FutureOr<void> _onTodoTasksAddEvent(
      TodoTasksAddEvent event, Emitter<ToDoTasksState> emit) {
    logger.log(Level.trace, "Start Add task event with task  ${event.task}");
    emit(TodoTaskLoadingState());
    tasks.add(event.task);
    _filterFunction();
    logger.log(Level.trace, "End Add task event with task  ${event.task}");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  FutureOr<void> _onTodoTasksChangeDoneVisibilityEvent(
      TodoTasksChangeDoneVisibilityEvent event, Emitter<ToDoTasksState> emit) {
    logger.log(Level.trace, "Start Change visibility event");
    emit(TodoTaskLoadingState());
    isComplitedHide = !isComplitedHide;
    _filterFunction();
    logger.log(Level.trace, "End Change visibility event");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  FutureOr<void> _onTodoTasksChangeTaskEvent(
      TodoTasksChangeTaskEvent event, Emitter<ToDoTasksState> emit) {
    logger.log(Level.trace, "Start Change event with task  ${event.task}");
    emit(TodoTaskLoadingState());
    tasks[tasks.indexWhere((element) => element.id == event.id)] = event.task;
    _filterFunction();
    logger.log(Level.trace, "End Change event with task  ${event.task}");
    emit(TodoTaskLoadedState(tasks: resultList, doneCounter: doneCounter));
  }

  void _filterFunction() {
    logger.log(Level.trace, "Start filter");
    final List<TodoTask> doneTasks =
        tasks.where((element) => element.done).toList();
    doneCounter = doneTasks.length;
    tasks.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
    resultList = tasks.where((element) => !element.done).toList() +
        (isComplitedHide ? [] : doneTasks);
    logger.log(Level.trace, "Filter done");
  }
}

List<TodoTask> todoTasks = [
  TodoTask(
      id: UniqueKey().toString(),
      text: "Купить что-то",
      importance: DegreeOfImportance.low,
      done: false,
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: "20062024"),
  TodoTask(
      id: UniqueKey().toString(),
      text: "Купить что-то",
      importance: DegreeOfImportance.high,
      done: false,
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: "20062024"),
  TodoTask(
      id: UniqueKey().toString(),
      text:
          "Купить что-то,где-то,зачем-то, но зачем непонятно,но точно чтобы показать как обр",
      importance: DegreeOfImportance.none,
      done: false,
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: "20062024"),
  TodoTask(
      id: UniqueKey().toString(),
      text: "Купить что-то,где-то,зачем-то, но зачем непонятно",
      importance: DegreeOfImportance.low,
      done: true,
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: "20062024",
      deadline: DateTime.now()),
  TodoTask(
      id: UniqueKey().toString(),
      text: "Купить что-то",
      importance: DegreeOfImportance.high,
      done: false,
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: "20062024"),
];
