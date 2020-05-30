import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';
import 'package:kerbal_remote_application/blocs/shared_prefs/shared_prefs_bloc.dart';
import 'package:kerbal_remote_application/proto/encoded_messages.dart';
import 'package:kerbal_remote_application/utils/logger.dart';

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
  final _urlController = TextEditingController()..text = '192.168.100.134';
  final _portController = TextEditingController()..text = '50000';
  final _streamController = TextEditingController()..text = '50001';
  final _nameController = TextEditingController()..text = 'KRApp';

  Timer timer;
  int timerCount = 0;

  String _clientID;

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
    widgets.add(_buildClientIDLabel());
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
    return BlocListener<KrappConnBloc, KrappConnState>(
      listener: (_, state) {
        // When state is 'CONNECTING...' make the RPC request for client ID,
        // to make sure connection is working.
        if (state is ConnectingKrappConnState) {
          BlocProvider.of<KrappConnBloc>(context).add(
            RpcRequestKrappConnEvent(EncodedMessages.getClientIDRequest())
          );
        } else if (state is RpcResponseKrappConnState) {

        }
      },
      child: BlocBuilder<KrappConnBloc, KrappConnState>(
        builder: (_, state) {

          String textButton;
          VoidCallback _pressCallback;

          if (state is DisconnectedKrappConnState) {
            textButton = 'CONNECT';
            _pressCallback = () => BlocProvider.of<KrappConnBloc>(context).add(
              ConnectKrappConnEvent(
                _urlController.text,
                int.parse(_portController.text),
                int.parse(_streamController.text),
                _nameController.text
              )
            );
          } else if (state is ConnectingKrappConnState) {
            textButton = 'CONNECTING...';
            _pressCallback = null;

          } else if (state is ConnectedKrappConnState ||
              state is RpcResponseKrappConnState) {
            textButton = 'DISCONNECT';
            _pressCallback = () => BlocProvider.of<KrappConnBloc>(context).add(
              DisconnectKrappConnEvent()
            );
          } else if (state is ErrorKrappConnState) {
            textButton = 'ERROR! RESET?';
            _pressCallback = () => BlocProvider.of<KrappConnBloc>(context).add(
              DisconnectKrappConnEvent()
            );
          }

          return RaisedButton(
            onPressed: _pressCallback,
            child: Text(textButton),
          );
        },
      ),
    );
  }

  Widget _buildClientIDLabel() {
    return BlocListener<KrappConnBloc, KrappConnState>(
      listener: (_, state) {
        if (state is RpcResponseKrappConnState) {
          logD(state.data.toString());
        }
      },
      child: Container(
        child: Row(
          children: <Widget>[
            // todo: adapt using theme
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Client ID: ', textScaleFactor: 1.5, textAlign: TextAlign.right,),
            )),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_clientID ?? 'UNKNOWN', textScaleFactor: 1.5, textAlign: TextAlign.left,),
            ),),
          ],
        ),
      ),
    );
  }
}
