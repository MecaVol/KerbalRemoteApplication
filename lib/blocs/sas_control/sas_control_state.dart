part of 'sas_control_bloc.dart';

@immutable
abstract class SasControlState {}

class UnknownSasControlState extends SasControlState {}

class SasOnState extends SasControlState {}
class SasOffState extends SasControlState {}
