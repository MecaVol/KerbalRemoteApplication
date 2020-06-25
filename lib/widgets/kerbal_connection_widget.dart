import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/shared_prefs/shared_prefs_bloc.dart';
import 'package:kerbal_remote_application/connection/client.dart';
import 'package:kerbal_remote_application/utils/logger.dart';
import 'package:provider/provider.dart';

/// Widget responsible to connect to KSP. User to set IP, port and optionnally
/// the name of the connection (to display in kRPC)
///
/// This widget uses 2 blocs, the [SharedPrefsBloc] for getting previous
/// settings, and the [KrappConnBloc] for sending connection requests
/// and receive the state of the connection.
class KerbalConnectionWidget extends StatefulWidget {

  @override
  _KerbalConnectionWidgetState createState() => _KerbalConnectionWidgetState();
}

class _KerbalConnectionWidgetState extends State<KerbalConnectionWidget> {

  final _urlController = TextEditingController()..text = '192.168.100.33';
  final _portController = TextEditingController()..text = '50000';
  final _streamController = TextEditingController()..text = '50001';
  final _nameController = TextEditingController()..text = 'KRApp';

  @override
  Widget build(BuildContext context) {
    return BlocListener<SharedPrefsBloc, SharedPrefsState>(
      listener: (context, state) {
        if (state is LastIPs) {
          _urlController.text = state.ips.last;
        } else {
          _urlController.text = '192.168.100.21';
        }
      },
      child: BlocBuilder<SharedPrefsBloc, SharedPrefsState>(
        builder: (context, state) {
          if (state is LastIPs) {
            return _buildColumnWithLastIPs(state.ips);
          } else {
            return _buildColumn();
          }
        },
      ),
    );
  }

  Widget _buildColumnWithLastIPs(List<String> ips) {

    return Column();
  }

  Widget _buildColumn() {
    var widgets = <Widget>[];
    widgets.addAll(_buildTextFieldList());
    widgets.add(_buildConnectionButton());
    return ListView(
      children: widgets,
    );
  }

  List<Widget> _buildTextFieldList({String ip, String port, String name}) {
    var widgets = <Widget>[];

    widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('IP:', textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _urlController,
                  onSubmitted: (value) {
                    _urlController.text = value.trim();
                  },
                ),
              )
            ],
          ),
        )
    );

    widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('PORT:', textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _portController,
                ),
              )
            ],
          ),
        )
    );

    widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('STREAM:', textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _streamController,
                ),
              )
            ],
          ),
        )
    );

    widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('NAME:', textAlign: TextAlign.center,),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _nameController,
                ),
              )
            ],
          ),
        )
    );
    return widgets;
  }

  Widget _buildConnectionButton() {
    return StreamBuilder<CONNECTION_STATE>(
        stream: Provider.of<Client>(context).state,
        initialData: CONNECTION_STATE.DISCONNECTED,
        builder: (_, snapshot) {

          String textButton;
          String connectionStatus;
          VoidCallback pressCallback;

          logD('Connection Widget received State: ' + snapshot.data.toString());

          if (snapshot.data == CONNECTION_STATE.DISCONNECTED) {
            textButton = 'CONNECT';
            connectionStatus = 'Disconnected';
            pressCallback = () =>
                Provider.of<Client>(context, listen: false).connect(
                    url: _urlController.text,
                    rpcPort: int.parse(_portController.text),
                    streamPort: int.parse(_streamController.text),
                    name: _nameController.text
                );

          } else if (snapshot.data == CONNECTION_STATE.WAITING) {
            textButton = 'CONNECTING...';
            connectionStatus = 'Connecting...';
            pressCallback = null;

          } else if (snapshot.data == CONNECTION_STATE.CONNECTED) {
            textButton = 'DISCONNECT';
            connectionStatus = 'Connected. ID: ';
            pressCallback = () => Provider.of<Client>(context, listen: false).disconnect();

          } else if (snapshot.data == CONNECTION_STATE.ERROR) {
            textButton = 'ERROR! RETRY??';
            connectionStatus = 'Error!';
            pressCallback = () => Provider.of<Client>(context, listen: false).connect(
                url: _urlController.text,
                rpcPort: int.parse(_portController.text),
                streamPort: int.parse(_streamController.text),
                name: _nameController.text
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: pressCallback,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(textButton, textScaleFactor: 1.5,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: Text('STATUS:'),),
                        Expanded(flex: 3, child: Text(connectionStatus, textAlign: TextAlign.center,),)
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
  }
}
