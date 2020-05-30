import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';
import 'package:kerbal_remote_application/proto/encoded_messages.dart';
import 'package:kerbal_remote_application/utils/logger.dart';
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
            title: Text('SEVER STATUS'),
            onExpansionChanged: (value) {
              if (value) { // Tile is expanded
                BlocProvider.of<KrappConnBloc>(context).add(
                    RpcRequestKrappConnEvent(EncodedMessages.getServerStatus())
                );
              }
            },
            children: <Widget>[
              BlocBuilder<KrappConnBloc, KrappConnState>(
                builder: (context, state) {
                  if (state is ErrorKrappConnState) {
                    return Text('ERROR!');
                  } else {
                    return Text('?');
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
