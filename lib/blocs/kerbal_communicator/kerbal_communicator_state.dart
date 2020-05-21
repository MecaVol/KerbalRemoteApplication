part of 'kerbal_communicator_bloc.dart';

@immutable
abstract class KerbalCommunicatorState {}

class InitialKerbalCommunicatorState extends KerbalCommunicatorState {}

class ResponseKerbalCommunicatorState extends KerbalCommunicatorState {
  final KraResponse _response;

  KraResponse get response => _response;

  ResponseKerbalCommunicatorState(this._response);
}