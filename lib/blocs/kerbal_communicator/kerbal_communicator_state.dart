part of 'kerbal_communicator_bloc.dart';

@immutable
abstract class KrappComState {}

class IdleKerbalComState extends KrappComState {}

class JsonResponseKrappComState extends KrappComState {
  final Map<String, dynamic> _json;
  Map<String, dynamic> get json => _json;
  JsonResponseKrappComState(this._json);
}