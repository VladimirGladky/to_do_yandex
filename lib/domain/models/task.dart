import 'package:flutter/material.dart';

enum DegreeOfImportance { none, low, high }

class TodoTask {
  final String id;
  String text;
  DegreeOfImportance importance;

  DateTime? deadline;
  Color? color;
  bool done;

  DateTime createdAt;
  DateTime changedAt;
  String lastUpdatedBy;

  TodoTask(
      {required this.id,
      required this.text,
      required this.importance,
      required this.done,
      this.deadline,
      required this.createdAt,
      required this.changedAt,
      required this.lastUpdatedBy});
}
