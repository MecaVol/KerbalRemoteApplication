part of 'kerbal_communicator_bloc.dart';

@immutable
abstract class KerbalComEvent {}

class SetRPCKerbalComEvent extends KerbalComEvent {
  final StreamSink<dynamic> _dataSink;
  final Stream<dynamic> _dataStream;

  StreamSink<dynamic> get rpcSink => _dataSink;
  Stream<dynamic> get rpcStream => _dataStream;

  SetRPCKerbalComEvent(this._dataSink, this._dataStream);
}