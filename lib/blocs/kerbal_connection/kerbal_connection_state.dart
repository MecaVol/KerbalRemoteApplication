part of 'kerbal_connection_bloc.dart';

@immutable
abstract class KrappConnState {}

class WaitingKrappConnState extends KrappConnState {}

class ErrorKrappConnState extends KrappConnState {
  final String _message;

  ErrorKrappConnState([this._message = 'Undefined error']) {
    logE('CONNECTION ERRROR: ' + _message);
  }
}

class StatusKrappConnState extends KrappConnState {
  final CONNECTION_STATUS _status;

  CONNECTION_STATUS get status => _status;

  StatusKrappConnState(this._status);
}

class RpcResponseKrappConnState extends KrappConnState {
  // todo: Response stuff
}

class StreamKrappConnState extends KrappConnState {
  // todo: Stream stuff
}