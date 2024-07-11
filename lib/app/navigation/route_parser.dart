import 'package:flutter/material.dart';
import 'package:to_do/app/navigation/navigation_state.dart';
import 'package:to_do/app/navigation/routes.dart';

class CustomRouteInformationParser
    extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return NavigationState.root();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == AppRoutes.taskAddRoute) {
        return NavigationState.add();
      }

      return NavigationState.root();
    }

    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == AppRoutes.taskDetailsRoute) {
        final taskId = uri.pathSegments[1];
        return NavigationState.item(taskId);
      }

      return NavigationState.unknown();
    }
    return NavigationState.root();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration.isAdd) {
      return RouteInformation(uri: Uri(path: '/${AppRoutes.taskAddRoute}'));
    }

    if (configuration.isDetailsScreen) {
      return RouteInformation(
          uri: Uri(
              path:
                  '/${AppRoutes.taskDetailsRoute}/${configuration.selectedTaskId}'));
    }

    if (configuration.isUnknown) {
      return null;
    }

    return RouteInformation(uri: Uri(path: '/${AppRoutes.homeRoute}'));
  }
}
