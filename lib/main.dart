import 'package:flutter/material.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'pages/home_page.dart';
import 'themes/theme_generator.dart';

void main() {runApp(KerbalRemoteApp());}

class KerbalRemoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeGenerator.getDefaultTheme(),
      home: LogConsoleOnShake(
        child: HomePage()
      ),
    );
  }
}
