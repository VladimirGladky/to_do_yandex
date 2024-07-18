import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do/app/firebase/firebase_config.dart';
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
    FirebaseRemoteConfig.instance.onConfigUpdated.listen((event) async {
      await FirebaseRemoteConfig.instance.activate();
      add(PriorityColorChangeTaskEvent());
    });
    on<TodoTasksLoadEvent>(_onTasksListLoadEvent);
    on<TodoTasksChangeDoneEvent>(_onTasksChangeDoneEvent);
    on<TodoTasksRemoveEvent>(_onTasksRemoveEvent);
    on<TodoTasksAddEvent>(_onTodoTasksAddEvent);
    on<TodoTasksChangeDoneVisibilityEvent>(
        _onTodoTasksChangeDoneVisibilityEvent);
    on<TodoTasksChangeTaskEvent>(_onTodoTasksChangeTaskEvent);
    on<PriorityColorChangeTaskEvent>(_updateColor);
  }

  FutureOr<void> _updateColor(
      PriorityColorChangeTaskEvent event, Emitter<ToDoTasksState> emit) {
    emit(TodoTaskLoadingState());
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
  }

  FutureOr<void> _onTasksListLoadEvent(
      TodoTasksLoadEvent event, Emitter<ToDoTasksState> emit) async {
    logger.d("Start task loading event");
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
    logger.d(
        "End load task event\nResultative list length: ${_resultList.length.toString()}");
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
  }

  FutureOr<void> _onTasksChangeDoneEvent(
      TodoTasksChangeDoneEvent event, Emitter<ToDoTasksState> emit) async {
    logger.d("Start change_done event for task with ${event.id} id");
    GetIt.I<FirebaseAppConfig>().analytics.analyticDoneEvent();
    int changedTaskId =
        _tasks.lastIndexWhere((element) => element.id == event.id);
    int changedTaskFilteredId =
        _resultList.lastIndexWhere((element) => element.id == event.id);
    _tasks[changedTaskId] =
        _tasks[changedTaskId].copyWith(done: !_tasks[changedTaskId].done);
    _resultList[changedTaskFilteredId] = _tasks[changedTaskId];
    emit(TodoTaskLoadedState(
        tasks: _resultList,
        doneCounter:
            _tasks[changedTaskId].done ? _doneCounter + 1 : _doneCounter));

    await Future<void>.delayed(const Duration(milliseconds: 450));
    emit(TodoTaskLoadingState());
    _filterFunction();
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    try {
      await repository.editTask(_tasks[changedTaskId]);
    } catch (e) {
      logger.d("Error: ${e.toString()}");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
    logger.d("End change_done event for task with ${event.id} id");
  }

  FutureOr<void> _onTasksRemoveEvent(
      TodoTasksRemoveEvent event, Emitter<ToDoTasksState> emit) async {
    logger.d("Start remove_event for task with ${event.id} id");
    GetIt.I<FirebaseAppConfig>().analytics.analyticDeleteEvent();
    emit(TodoTaskLoadingState());

    _tasks.removeWhere((element) => element.id == event.id);
    _filterFunction();
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    try {
      await repository.removeTask(event.id);
    } catch (e) {
      logger.d("Error: ${e.toString()}");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
    logger.d("End remove_event for task with ${event.id} id");
  }

  FutureOr<void> _onTodoTasksAddEvent(
      TodoTasksAddEvent event, Emitter<ToDoTasksState> emit) async {
    logger.d("Start add_task event with task  ${event.task}");
    GetIt.I<FirebaseAppConfig>().analytics.addTaskEvent();
    emit(TodoTaskLoadingState());

    _tasks.add(event.task);
    _filterFunction();
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    try {
      await repository.addTask(event.task);
    } catch (e) {
      logger.e("Error: ${e.toString()}");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
    logger.d("End add_task event with task  ${event.task.toString()}");
  }

  FutureOr<void> _onTodoTasksChangeDoneVisibilityEvent(
      TodoTasksChangeDoneVisibilityEvent event, Emitter<ToDoTasksState> emit) {
    logger.d("Start change_visibility event to ${!isComplitedHide}");
    emit(TodoTaskLoadingState());
    _isComplitedHide = !_isComplitedHide;
    _filterFunction();
    logger.d("End change_visibility event");
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
  }

  FutureOr<void> _onTodoTasksChangeTaskEvent(
      TodoTasksChangeTaskEvent event, Emitter<ToDoTasksState> emit) async {
    logger.d("Start change_event with task id ${event.task.id}");
    emit(TodoTaskLoadingState());
    int i = _tasks.indexWhere((element) => element.id == event.id);

    _tasks[i] = event.task;
    _filterFunction();
    emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));

    try {
      await repository.editTask(event.task);
    } catch (e) {
      logger.d("Error: $e");
      emit(
          TodoTaskErrorState(errorMessage: (e as MyExceptions).errorMessage()));
      emit(TodoTaskLoadedState(tasks: _resultList, doneCounter: _doneCounter));
    }
    logger.d("End change_event with task id ${event.task.id}");
  }

  void _filterFunction() {
    logger.d("Start filter");
    final List<TodoTask> doneTasks =
        _tasks.where((element) => element.done).toList();
    _doneCounter = doneTasks.length;
    _tasks.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
    _resultList = _tasks.where((element) => !element.done).toList() +
        (isComplitedHide ? [] : doneTasks);
    logger.d("Filter done");
  }
}
