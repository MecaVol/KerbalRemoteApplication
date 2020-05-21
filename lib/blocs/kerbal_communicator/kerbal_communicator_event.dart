part of 'kerbal_communicator_bloc.dart';

@immutable
abstract class KerbalCommunicatorEvent {}

class SetConnectionKerbalCommunicatorEvent extends KerbalCommunicatorEvent {
  final StreamSink<dynamic> _dataSink;

  StreamSink<dynamic> get sink => _dataSink;

  SetConnectionKerbalCommunicatorEvent(this._dataSink);
}

class RequestKerbalCommunicatorEvent extends KerbalCommunicatorEvent {
  final KraRequest _request;

  RequestKerbalCommunicatorEvent(this._request);
}