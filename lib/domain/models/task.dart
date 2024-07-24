import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

@freezed
class TodoTask with _$TodoTask {
  factory TodoTask(
      {required String id,
      required String text,
      required DegreeOfImportance importance,
      required bool done,
      required bool isSynchronized,
      DateTime? deadline,
      Color? color,
      required DateTime createdAt,
      required DateTime changedAt,
      required String lastUpdatedBy}) = _TodoTask;
}

enum DegreeOfImportance { none, low, high }
