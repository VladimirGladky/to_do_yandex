import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/generated/l10n.dart';
import 'package:to_do/presentation/screnns/main_screen/main_screen.dart';
import 'package:to_do/utils/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoTasksBloc()..add(TodoTasksLoadEvent()),
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'to_do',
        theme: lightTheme(),
        home: const MainScreen(),
      ),
    );
  }
}
