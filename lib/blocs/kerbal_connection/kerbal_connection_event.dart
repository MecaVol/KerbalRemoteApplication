part of 'kerbal_connection_bloc.dart';

@immutable
abstract class KrappConnEvent {}

class StatusKrappConnEvent extends KrappConnEvent {}

class ConnectKrappConnEvent extends KrappConnEvent {

  final String url;
  final int port;
  final String name;

  ConnectKrappConnEvent(this.url, this.port, [this.name = "KRApp"]);
}

class DisconnectKrappConnEvent extends KrappConnEvent {}

class RpcRequestKrappConnEvent extends KrappConnEvent {
  // todo: add Request data
}

class StreamSubscriptionKrappConnEvent extends KrappConnEvent {}
