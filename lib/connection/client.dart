import 'dart:async';
import 'dart:typed_data';

import 'package:kerbal_remote_application/proto/encoded_messages.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum CONNECTION_STATE {
  DISCONNECTED,
  WAITING,
  CONNECTED,
  ERROR
}

class Client {

  static const String DEFAULT_URL = '127.0.0.1';
  static const int DEFAULT_RPC_PORT = 50000;
  static const int DEFAULT_STREAM_PORT = 50001;
  static const String DEFAULT_NAME = 'KrApp';

  WebSocketChannel _rpcChannel;
  StreamSubscription _rpcSubscription;
  final _stateController = StreamController<CONNECTION_STATE>.broadcast()
    ..add(CONNECTION_STATE.DISCONNECTED);

  Stream<CONNECTION_STATE> state;
  Stream<Uint8List> rpc;

  Client() {
    state = _stateController.stream;
  }

  void connect({
      String url = DEFAULT_URL,
      int rpcPort = DEFAULT_RPC_PORT,
      int streamPort = DEFAULT_STREAM_PORT,
      String name = DEFAULT_NAME
  }) {
    _stateController.add(CONNECTION_STATE.WAITING);
    Uri rpcUri = Uri.parse("ws://" + url + ":" + rpcPort.toString() + "/?name=" + name);
    _rpcChannel = IOWebSocketChannel.connect(rpcUri);

    _rpcSubscription = _rpcChannel.stream.listen((event) {
      _stateController.add(CONNECTION_STATE.CONNECTED);
    }, onError: (error) {
      _stateController.add(CONNECTION_STATE.ERROR);
    }, onDone: () {
      _stateController.add(CONNECTION_STATE.DISCONNECTED);
    });

    _rpcChannel.sink.add(EncodedMessages.getClientIDRequest());
  }

  void disconnect() {
    _rpcChannel?.sink?.close();
  }
}