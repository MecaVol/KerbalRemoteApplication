import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sas_control_event.dart';

part 'sas_control_state.dart';

class SasControlBloc extends Bloc<SasControlEvent, SasControlState> {

  @override
  SasControlState get initialState => UnknownSasControlState();

  @override
  Stream<SasControlState> mapEventToState(SasControlEvent event) async* {
    if (event is SasOnEvent) {
      yield SasOnState();
    } else if (event is SasOffEvent) {
      yield SasOffState();
    }
  }
}
