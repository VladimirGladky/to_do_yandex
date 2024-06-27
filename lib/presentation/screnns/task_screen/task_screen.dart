import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/generated/l10n.dart';
import 'package:to_do/presentation/screnns/task_screen/widgets/custom_drop_down_menu.dart';
import 'package:to_do/presentation/screnns/task_screen/widgets/custom_appbar.dart';
import 'package:to_do/presentation/screnns/task_screen/widgets/deletetask.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key, this.task});

  final TodoTask? task;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late TextEditingController _controller;
  DegreeOfImportance? dropdownvalue;
  bool chosendate = false;
  DateTime datenow = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    if (widget.task != null) {
      chosendate = widget.task!.deadline != null ? true : false;
      _controller.text = widget.task!.text;
      datenow = widget.task!.deadline ?? DateTime.now();
      dropdownvalue = widget.task!.importance;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void callbackdropdownvalue(DegreeOfImportance value) {
    setState(() {
      dropdownvalue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTaskScreenAppBar(
                  controller: _controller,
                  datenow: datenow,
                  chosendate: chosendate,
                  dropdownValue: dropdownvalue,
                  task: widget.task,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  constraints: const BoxConstraints(minHeight: 144),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.onSurface,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 1.0,
                        spreadRadius: 1,
                        offset: const Offset(0, 1.0),
                      ),
                    ],
                  ),
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: _controller,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: S.of(context).whatToDo,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.shadow),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
                  child: Text(S.of(context).priority),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, left: 16.0, top: 6, bottom: 10),
                  child: Customdropdownmenu(
                    dropdownvalue: dropdownvalue,
                    callbackvalue: callbackdropdownvalue,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).doneUntil,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (chosendate)
                            Text(DateFormat('dd.MM.yyyy').format(datenow),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor))
                        ],
                      ),
                      const Spacer(),
                      Switch(
                          activeColor: Theme.of(context).primaryColor,
                          value: chosendate,
                          onChanged: (bool value) async {
                            if (!value) {
                              setState(() {
                                chosendate = !chosendate;
                              });
                            } else {
                              final date = await pickDate(context, datenow);
                              if (date == null) return;
                              final newDatetime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                datenow.hour,
                                datenow.minute,
                              );
                              setState(() {
                                chosendate = !chosendate;
                                datenow = newDatetime;
                              });
                            }
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Divider(
                  thickness: 1,
                ),
                DeleteTask(task: widget.task),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate(BuildContext context, DateTime dateTime) {
    return showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: dateTime,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
  }
}
