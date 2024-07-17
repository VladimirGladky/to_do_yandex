import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do/domain/exception/exceptions.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:logger/logger.dart';
import 'package:to_do/domain/repository/to_do_repository.dart';

part 'to_do_tasks_event.dart';
part 'to_do_tasks_state.dart';

class ToDoTasksBloc extends Bloc<ToDoTasksEvent, ToDoTasksState> {
  late final TodoRepository repository;

  List<TodoTask> _resultList = [];
  List<TodoTask> _tasks = [];
  int _doneCounter = 0;
  var logger = Logger();
  bool _isComplitedHide = false;
  bool get isComplitedHide => _isComplitedHide;

  TodoTask? getTaskById(String? id) {
    if (id == null) return null;
    try {
      TodoTask resTask = _tasks.firstWhere((element) => element.id == id);
      return resTask;
    } catch (e) {
      return null;
    }
  }

  ToDoTasksBloc() : super(ToDoTasksInitial()) {
    repository = TodoRepository();
    on<TodoTasksLoadEvent>(_onTasksLoadEvent);
    on<TodoTasksChangeDoneEvent>(_onTasksChangeDoneEvent);
    on<TodoTasksRemoveEvent>(_onTasksRemoveEvent);
    on<TodoTasksAddEvent>(_onTodoTasksAddEvent);
    on<TodoTasksChangeDoneVisibilityEvent>(
        _onTodoTasksChangeDoneVisibilityEvent);
    on<TodoTasksChangeTaskEvent>(_onTodoTasksChangeTaskEvent);
  }

  FutureOr<void> _onTasksLoadEvent(
      TodoTasksLoadEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(Level.trace, "Start load task event");
    emit(TodoTaskLoadingState());
    List<TodoTask> tmpList = [];
    try {
      tmpList = await repository.getAndMergeTasks();
    } catch (e) {
      logger.e("Error: ${e.toString()}");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
    _tasks = tmpList;
    _filterFunction();
    logger.log(Level.trace,
        "End load task event\nResultative list: ${_resultList.toString()}");
    logger.log(Level.trace, jsonEncode("tasks: ${_tasks.toString()}"));
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
  }

  FutureOr<void> _onTasksChangeDoneEvent(
      TodoTasksChangeDoneEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(
        Level.trace, "Start Change Done event for task with ${event.id} id");

    TodoTask changedTask =
        _tasks.firstWhere((element) => element.id == event.id);
    changedTask.done = !changedTask.done;

    emit(TodoTaskLoadedState(
        tasks: _resultList,
        doneCounter: changedTask.done ? _doneCounter + 1 : _doneCounter));

    await Future<void>.delayed(const Duration(milliseconds: 850));
    emit(TodoTaskLoadingState());
    _filterFunction();
    logger.log(
        Level.trace, "End Change Done event for task with ${event.id} id");
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    //int statusCode;

    try {
      await repository.editTask(changedTask);
    } catch (e) {
      logger.e("Error: ${e.toString()}");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
  }

  FutureOr<void> _onTasksRemoveEvent(
      TodoTasksRemoveEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(Level.trace, "Start Remove event for task with ${event.id} id");
    emit(TodoTaskLoadingState());

    _tasks.removeWhere((element) => element.id == event.id);
    _filterFunction();
    logger.log(Level.trace, "End Remove event for task with ${event.id} id");
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    try {
      await repository.removeTask(event.id);
    } catch (e) {
      logger.e("Error: ${e.toString()}");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
  }

  FutureOr<void> _onTodoTasksAddEvent(
      TodoTasksAddEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(Level.trace, "Start Add task event with task  ${event.task}");
    emit(TodoTaskLoadingState());

    _tasks.add(event.task);
    _filterFunction();
    logger.log(Level.trace, "End Add task event with task  ${event.task}");
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    try {
      await repository.addTask(event.task);
    } catch (e) {
      logger.e("Error: ${e.toString()}");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
  }

  FutureOr<void> _onTodoTasksChangeDoneVisibilityEvent(
      TodoTasksChangeDoneVisibilityEvent event, Emitter<ToDoTasksState> emit) {
    logger.log(Level.trace, "Start Change visibility event");
    emit(TodoTaskLoadingState());
    _isComplitedHide = !_isComplitedHide;
    _filterFunction();
    logger.log(Level.trace, "End Change visibility event");
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
  }

  FutureOr<void> _onTodoTasksChangeTaskEvent(
      TodoTasksChangeTaskEvent event, Emitter<ToDoTasksState> emit) async {
    logger.log(Level.trace, "Start Change event with task  ${event.task}");
    emit(TodoTaskLoadingState());
    int i = _tasks.indexWhere((element) => element.id == event.id);

    _tasks[i] = event.task;
    _filterFunction();
    logger.log(Level.trace, "End Change event with task  ${event.task}");
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));

    try {
      await repository.editTask(event.task);
    } catch (e) {
      logger.e("Error: ${e.toString()}");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
  }

  void _filterFunction() {
    logger.log(Level.trace, "Start filter");
    final List<TodoTask> doneTasks =
        _tasks.where((element) => element.done).toList();
    _doneCounter = doneTasks.length;
    _tasks.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
    _resultList = _tasks.where((element) => !element.done).toList() +
        (isComplitedHide ? [] : doneTasks);
    logger.log(Level.trace, "Filter done");
  }
}
