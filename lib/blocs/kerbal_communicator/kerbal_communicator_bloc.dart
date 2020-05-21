import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kerbal_remote_application/model/kra_request.dart';
import 'package:kerbal_remote_application/model/kra_response.dart';
import 'package:meta/meta.dart';

part 'kerbal_communicator_event.dart';

part 'kerbal_communicator_state.dart';

class KerbalCommunicatorBloc
    extends Bloc<KerbalCommunicatorEvent, KerbalCommunicatorState> {
  @override
  KerbalCommunicatorState get initialState => InitialKerbalCommunicatorState();

  @override
  Stream<KerbalCommunicatorState> mapEventToState(
      KerbalCommunicatorEvent event) async* {
    // TODO: Add your event logic
  }
}
