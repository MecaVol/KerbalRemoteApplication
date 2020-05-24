import 'package:test/test.dart';

import 'package:kerbal_remote_application/blocs/kerbal_connection/kerbal_connection_bloc.dart';

void main() {
  group('KerbalConnectionEvent tests', () {
    test('StartKerbalConnectionEvent test', () {
      var connectionEvent = ConnectKrappConnEvent(
          'myUrl', 1234, 'connectionName');
      expect(connectionEvent, isNotNull);
    });
  });
}