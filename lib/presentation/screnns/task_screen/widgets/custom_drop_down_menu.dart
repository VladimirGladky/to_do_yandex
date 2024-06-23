import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/utils/constutils.dart';

const List<degreeofImportance> items = [
  degreeofImportance.high,
  degreeofImportance.low,
  degreeofImportance.none
];

class Customdropdownmenu extends StatelessWidget {
  const Customdropdownmenu(
      {super.key, required this.dropdownvalue, required this.callbackvalue});

  final degreeofImportance? dropdownvalue;
  final Function callbackvalue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<degreeofImportance>(
      isDense: true,
      value: dropdownvalue,
      elevation: 16,
      style: Theme.of(context).textTheme.bodyMedium,
      hint: Text("Нет",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.shadow)),
      onChanged: (degreeofImportance? value) {
        callbackvalue(value);
      },
      icon: const SizedBox(),
      iconSize: 0,
      underline: const SizedBox(),
      items: items.map<DropdownMenuItem<degreeofImportance>>(
        (degreeofImportance value) {
          return DropdownMenuItem<degreeofImportance>(
            value: value,
            child: switch (value) {
              degreeofImportance.none => Text(
                  "Нет",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              degreeofImportance.low =>
                Text("Низкий", style: Theme.of(context).textTheme.bodyMedium),
              degreeofImportance.high => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(MyIcons.kHighPriorityIcon),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Высокий",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: ColorPaletteLight.kColorRed),
                    ),
                  ],
                ),
            },
          );
        },
      ).toList(),
    );
  }
}
