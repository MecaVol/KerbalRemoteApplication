part of 'kerbal_connection_bloc.dart';

@immutable
abstract class KrappConnState {}

/// Initial State. It also shows that the connection is reset completely.
class DisconnectedKrappConnState extends KrappConnState {}

/// Temporary state, while waiting for the connection to establish or fail.
class ConnectingKrappConnState extends KrappConnState {}

/// Connected event, providing a KrappData stream to allow stream building
/// widget if needed.
class ConnectedKrappConnState extends KrappConnState {
  final Stream<KrappData> _rpcStream;
  Stream<KrappData> get rpcStream => _rpcStream;
  ConnectedKrappConnState(this._rpcStream) {}
}

/// A unitary RPC response from server, with no TCP connection error.
/// Warning: it may be fired in case of protobuf error sent by kRPC server!
class RpcResponseKrappConnState extends KrappConnState {
  final Uint8List _data;
  Uint8List get data => _data;
  RpcResponseKrappConnState(this._data);
}

class StreamKrappConnState extends KrappConnState {
  // todo: Stream stuff
}

/// Fired when a TCP connection error has been encountered. It may be due to
/// wrong parameters in initial connection request, or any connectivity
/// problem.
class ErrorKrappConnState extends KrappConnState {
  final String _message;

  ErrorKrappConnState([this._message = 'Undefined error']) {
    logE('CONNECTION ERRROR: ' + _message);
  }
}

