part of 'kerbal_communicator_bloc.dart';

@immutable
abstract class KrappComEvent {}

class ResponseKrappComEvent extends KrappComEvent {
  final Uint8List _data;
  Uint8List get data => _data;
  ResponseKrappComEvent(this._data);
}