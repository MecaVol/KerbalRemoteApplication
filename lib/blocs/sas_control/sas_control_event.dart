part of 'sas_control_bloc.dart';

@immutable
abstract class SasControlEvent {}

class SasOnEvent extends SasControlEvent {}
class SasOffEvent extends SasControlEvent {}
