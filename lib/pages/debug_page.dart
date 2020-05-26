import 'package:flutter/material.dart';
import 'package:kerbal_remote_application/widgets/kerbal_connection_icon.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TESTS'),
        actions: <Widget>[
          KrappConnIcon(),
        ],
      ),
    );
  }
}
