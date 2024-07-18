import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do/app/navigation/route_parser.dart';
import 'package:to_do/app/navigation/router_delegate.dart';
import 'package:to_do/domain/bloc/to_do_tasks_bloc/to_do_tasks_bloc.dart';
import 'package:to_do/generated/l10n.dart';
import 'package:to_do/utils/dark_theme.dart';
import 'package:to_do/utils/light_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoTasksBloc()..add(TodoTasksLoadEvent()),
      child: MaterialApp.router(
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
        darkTheme: darkTheme(),
        routerDelegate: GetIt.I<MyRouterDelegate>(),
        routeInformationParser: GetIt.I<CustomRouteInformationParser>(),
      ),
    );
  }
}
