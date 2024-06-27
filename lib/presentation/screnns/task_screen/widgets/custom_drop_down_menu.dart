import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/domain/models/task.dart';
import 'package:to_do/utils/constutils.dart';

const List<DegreeOfImportance> items = [
  DegreeOfImportance.high,
  DegreeOfImportance.low,
  DegreeOfImportance.none
];

class Customdropdownmenu extends StatelessWidget {
  const Customdropdownmenu(
      {super.key, required this.dropdownvalue, required this.callbackvalue});

  final DegreeOfImportance? dropdownvalue;
  final Function callbackvalue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DegreeOfImportance>(
      isDense: true,
      value: dropdownvalue,
      elevation: 16,
      style: Theme.of(context).textTheme.bodyMedium,
      hint: Text("Нет",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.shadow)),
      onChanged: (DegreeOfImportance? value) {
        callbackvalue(value);
      },
      icon: const SizedBox(),
      iconSize: 0,
      underline: const SizedBox(),
      items: items.map<DropdownMenuItem<DegreeOfImportance>>(
        (DegreeOfImportance value) {
          return DropdownMenuItem<DegreeOfImportance>(
            value: value,
            child: switch (value) {
              DegreeOfImportance.none => Text(
                  "Нет",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              DegreeOfImportance.low =>
                Text("Низкий", style: Theme.of(context).textTheme.bodyMedium),
              DegreeOfImportance.high => Row(
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
