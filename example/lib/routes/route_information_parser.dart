import 'package:flutter/material.dart';

class MyRouteInformationParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) {
    // print(' --- ${routeInformation.location} --- ');
    return Future.value(
      Uri.parse(routeInformation.location ?? ''),
    );
  }

  @override
  RouteInformation? restoreRouteInformation(Uri configuration) {
    return RouteInformation(
      location: configuration.toString(),
    );
  }
}
