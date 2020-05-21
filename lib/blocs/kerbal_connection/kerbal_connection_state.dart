part of 'kerbal_connection_bloc.dart';

@immutable
abstract class KerbalConnectionState {}

class InitialKerbalConnectionState extends KerbalConnectionState {}

class ErrorKerbalConnectionState extends KerbalConnectionState {
  final _message;

  ErrorKerbalConnectionState([this._message = 'Undefined error']) {
    logE(_message);
  }
}

class GoodKerbalConnectionState extends KerbalConnectionState {
  final String _clientIdentifier;

  GoodKerbalConnectionState(this._clientIdentifier);

  String get identifier => _clientIdentifier;
}

class WaitingKerbalConnectionState extends KerbalConnectionState {}