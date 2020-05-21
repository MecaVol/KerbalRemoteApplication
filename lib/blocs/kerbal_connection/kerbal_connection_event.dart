part of 'kerbal_connection_bloc.dart';

@immutable
abstract class KerbalConnectionEvent {}

class StartKerbalConnectionEvent extends KerbalConnectionEvent {
  final String _url;
  final int _port;
  final String _name;

  StartKerbalConnectionEvent(this._url, this._port, [this._name = "KRApp"]);
}

class StopKerbalConnectionEvent extends KerbalConnectionEvent {}
