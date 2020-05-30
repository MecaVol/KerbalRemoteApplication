part of 'kerbal_connection_bloc.dart';

@immutable
abstract class KrappConnEvent {}

/// Request for connection event. It requires some fields to build the Uri, but
/// it connects to localhost with default kRPC server ports if not provided.
class ConnectKrappConnEvent extends KrappConnEvent {

  final String url;
  final int port;
  final int stream;
  final String name;

  ConnectKrappConnEvent(this.url, this.port, this.stream, [this.name = "KRApp"]) {
    logD('CONNECTION REQUEST: url=' + url + ' port=' + port.toString() +
        ' stream=' + stream.toString() + ' name=' + name);
  }
}

/// Request for kRPC disconnection.
class DisconnectKrappConnEvent extends KrappConnEvent {}

/// Event to handle a RPC request. It has to be encoded already!
class RpcRequestKrappConnEvent extends KrappConnEvent {
  final Uint8List _data;
  Uint8List get data => _data;
  RpcRequestKrappConnEvent(this._data) {}
}

/// Request for a kRPC data stream to start.
class StreamSubscriptionKrappConnEvent extends KrappConnEvent {
  // todo: do!
}
