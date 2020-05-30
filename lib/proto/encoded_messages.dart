import 'dart:typed_data' show Uint8List;

import 'package:kerbal_remote_application/proto/krpc.pb.dart'
  show Request, ProcedureCall;

class EncodedMessages{
  static Uint8List getClientIDRequest() {
    var request = Request()
        ..calls.add(
          ProcedureCall()
              ..service = 'KRPC'
              ..procedure = 'GetClientID'
        );

    return request.writeToBuffer();
  }

  static Uint8List getServerStatus() {
    var request = Request()
      ..calls.add(
          ProcedureCall()
            ..service = 'KRPC'
            ..procedure = 'GetServices'
      );

    return request.writeToBuffer();
  }
}