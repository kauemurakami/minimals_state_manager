import 'package:example/app/data/services/setup_locator.dart';
import 'package:example/routes/delegate.dart';
import 'package:flutter/material.dart';

import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  setupLocator();
  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: GoRootDelegate.router,
  ));
}
