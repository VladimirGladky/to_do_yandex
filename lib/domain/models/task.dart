enum DegreeOfImportance { none, low, high }

class TodoTask {
  final String id;
  final String text;
  final DegreeOfImportance importance;

  DateTime? deadline;
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
