import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';
import 'package:kerbal_remote_application/blocs/shared_prefs/shared_prefs_bloc.dart';

class KerbalConnectionWidget extends StatelessWidget {

  final _urlController = TextEditingController();
  final _portController = TextEditingController();
  final _nameController = TextEditingController();

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
    return BlocBuilder<KerbalConnectionBloc, KerbalConnectionState>(
      builder: (context, state) {
        if (state is GoodKerbalConnectionState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => BlocProvider.of<KerbalConnectionBloc>(context).add(
                StopKerbalConnectionEvent()
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('DISCONNECT')),
                  Icon(Icons.brightness_1, color: Colors.green,),
                ],
              ),
            ),
          );
        } else if (state is WaitingKerbalConnectionState){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => BlocProvider.of<KerbalConnectionBloc>(context).add(
                  StopKerbalConnectionEvent()
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('PLEASE WAIT... OR CANCEL!')),
                  Icon(Icons.brightness_1, color: Colors.orange,),
                ],
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () => BlocProvider.of<KerbalConnectionBloc>(context).add(
                  StartKerbalConnectionEvent(
                    _urlController.text,
                    int.parse(_portController.text),
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
