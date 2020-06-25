import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/proto/encoded_messages.dart';
import 'package:kerbal_remote_application/widgets/kerbal_connection_icon.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DEBUG'),
        actions: <Widget>[
          KrappConnIcon(),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text('ROUTES'),
            onExpansionChanged: (value) {

            },
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pushNamed(context, '/sas_control'),
                child: Text('SAS CONTROL'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
