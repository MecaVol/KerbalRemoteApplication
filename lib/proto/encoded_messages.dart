import 'dart:typed_data';

import 'package:kerbal_remote_application/proto/krpc.pb.dart';

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
}