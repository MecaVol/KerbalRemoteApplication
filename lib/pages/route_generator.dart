import 'package:flutter/material.dart';
import 'package:kerbal_remote_application/pages/connection_page.dart';
import 'package:kerbal_remote_application/pages/debug_page.dart';
import 'package:kerbal_remote_application/pages/sas_control_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => DebugPage());
      case '/connection':
        return MaterialPageRoute(builder: (_) => ConnectionPage());
      case '/sas_control':
        return MaterialPageRoute(builder: (_) => SasControlPage());
      default:
        return MaterialPageRoute(builder: (_) => DebugPage());
    }
  }
}
