import 'package:flutter/material.dart';

class MyRouteInformationParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) {
    print(' --- ${routeInformation.uri.pathSegments} --- ');
    return Future.value(routeInformation.uri);
  }

  @override
  RouteInformation? restoreRouteInformation(Uri configuration) {
    return RouteInformation(
        // location: configuration.toString(),
        uri: configuration);
  }
}
