import 'package:flutter/material.dart';
import 'package:kerbal_remote_application/widgets/kerbal_connection_widget.dart';

class ConnectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KERBAL kRPC connection'),
      ),
      body: KerbalConnectionWidget(),
    );
  }
}