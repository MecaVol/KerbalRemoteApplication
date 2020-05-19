import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';

class KerbalConnectionWidget extends StatefulWidget {
  @override
  _KerbalConnectionWidgetState createState() => _KerbalConnectionWidgetState();
}

class _KerbalConnectionWidgetState extends State<KerbalConnectionWidget> {

  TextEditingController _urlController = TextEditingController (
    text: "localhost"
  );

  TextEditingController _portController = TextEditingController (
    text: "1000"
  );

  TextEditingController _nameController = TextEditingController (
    text: "Kerbal Remote"
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KerbalConnectionBloc, KerbalConnectionState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _urlController,
                    textAlign: TextAlign.center,
                  ),
                ),),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _portController,
                    textAlign: TextAlign.center,
                  ),
                ),),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                  ),
                ),),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _ConnectionButton(
                      state,
                      _urlController.text,
                      int.parse(_portController.text),
                      _nameController.text
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _ConnectionStateWidget(state),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class _ConnectionStateWidget extends StatelessWidget {

  final KerbalConnectionState _state;

  _ConnectionStateWidget(this._state);

  @override
  Widget build(BuildContext context) {
    if (_state is GoodKerbalConnectionState) {
      return Icon(Icons.thumb_up, color: Colors.green,);
    } else if (_state is InitialKerbalConnectionState) {
      return Icon(Icons.help, color: Colors.blue,);
    } else if (_state is ErrorKerbalConnectionState) {
      return Icon(Icons.error, color: Colors.red,);
    }
    return null;
  }
}

class _ConnectionButton extends StatelessWidget {

  final KerbalConnectionState _state;
  final String _url;
  final int _port;
  final String _name;

  _ConnectionButton(this._state, this._url, this._port, this._name);

  Text get _text {
    if (_state is GoodKerbalConnectionState) {
      return Text('DISCONNECT');
    } else {
      return Text('CONNECT');
    }
  }

  KerbalConnectionEvent get _connectionEvent {
    if (_state is GoodKerbalConnectionState) {
      return StopKerbalConnectionEvent();
    } else {
      return StartKerbalConnectionEvent(_url, _port, _name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: _text,
      onPressed: () {
        BlocProvider.of<KerbalConnectionBloc>(context).add(_connectionEvent);
      },
    );
  }

}
