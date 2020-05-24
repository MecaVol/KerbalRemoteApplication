import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:kerbal_remote_application/proto/krpc.pb.dart' show Request, ProcedureCall;
import 'package:kerbal_remote_application/utils/logger.dart';

import 'package:meta/meta.dart';

part 'kerbal_communicator_event.dart';

part 'kerbal_communicator_state.dart';

/// This BLoC is responsible to handle protobuf messages, for both decoding and
/// encoding them.
///
/// It is provided with kRPC sink and stream to send requests and receive
/// responses, and to handle kRPC streams.
class KerbalComBloc
    extends Bloc<KerbalComEvent, KerbalComState> {

  StreamSink<dynamic> _rpcSink;
  Stream<dynamic> _rpcStream;

  @override
  KerbalComState get initialState => IdleKerbalComState();

  Uint8List _getClientIDRawRequest() {
    var request = Request();
    var procedureCall = ProcedureCall();
    procedureCall.service = 'KRPC';
    procedureCall.procedure = 'GetClientID';
    request.calls.add(procedureCall);
    return request.writeToBuffer();
  }

  @override
  Stream<KerbalComState> mapEventToState(
      KerbalComEvent event) async* {
    yield IdleKerbalComState();
    if (event is SetRPCKerbalComEvent) {
      _rpcSink = event.rpcSink;
      _rpcStream = event.rpcStream;
      _rpcSink.add(_getClientIDRawRequest());
      var rawResponse = await _rpcStream.first;
      logD(rawResponse.toString());
    }
  }
}
