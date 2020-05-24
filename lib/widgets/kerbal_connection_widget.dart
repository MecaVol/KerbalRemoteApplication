import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';
import 'package:kerbal_remote_application/blocs/shared_prefs/shared_prefs_bloc.dart';

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
  final _urlController = TextEditingController()..text = '127.0.0.1';
  final _portController = TextEditingController()..text = '1000';
  final _nameController = TextEditingController()..text = 'KRApp';

  Timer timer;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SharedPrefsBloc, SharedPrefsState>(
      listener: (context, state) {
        if (state is LastIPs) {
          _urlController.text = state.ips.last;
        } else {
          _urlController.text = "127.0.0.1";
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
    return Column(
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
    return BlocBuilder<KrappConnBloc, KrappConnState>(
      builder: (context, state) {
        // DISCONNECTED (initial status as well)
        if (state is StatusKrappConnState &&
            state.status == CONNECTION_STATUS.DISCONNECTED)
        {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => BlocProvider.of<KrappConnBloc>(context).add(
                  ConnectKrappConnEvent(
                      _urlController.text,
                      int.parse(_portController.text ?? '0'),
                      _nameController.text
                  )
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('CONNECT')),
                  Icon(Icons.brightness_1, color: Colors.blue,),
                ],
              ),
            ),
          );

        } else if (state is WaitingKrappConnState){
          timer = Timer(Duration(seconds: 1), () {
            BlocProvider.of<KrappConnBloc>(context).add(
                StatusKrappConnEvent());
          });
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => null,
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('PLEASE WAIT...')),
                  Icon(Icons.brightness_1, color: Colors.orange,),
                ],
              ),
            ),
          );
        } else if (state is StatusKrappConnState &&
                   state.status == CONNECTION_STATUS.ERROR)
        {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => BlocProvider.of<KrappConnBloc>(context).add(
                ConnectKrappConnEvent(
                    _urlController.text,
                    int.parse(_portController.text ?? '0'),
                    _nameController.text
                )
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('CORRECT IT AND... CONNECT!')),
                  Icon(Icons.brightness_1, color: Colors.red,),
                ],
              ),
            ),
          );
        } else if (state is StatusKrappConnState &&
                    state.status == CONNECTION_STATUS.CONNECTED)
        {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => BlocProvider.of<KrappConnBloc>(context).add(
                  DisconnectKrappConnEvent()
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('DISCONNECT')),
                  Icon(Icons.brightness_1, color: Colors.green,),
                ],
              ),
            ),
          );
        } else { // We shouldn't reach here!
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => BlocProvider.of<KrappConnBloc>(context).add(
                ConnectKrappConnEvent(
                  _urlController.text,
                  int.parse(_portController.text ?? '0'),
                  _nameController.text
                )
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('CONNECT')),
                  Icon(Icons.brightness_1, color: Colors.blue,),
                ],
              ),
            ),
          );
        }
      }
    );
  }
}
