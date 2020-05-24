import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/blocs/kerbal_communicator/kerbal_communicator_bloc.dart';
import 'package:kerbal_remote_application/proto/encoded_messages.dart';
import 'package:kerbal_remote_application/utils/logger.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'kerbal_connection_event.dart';

part 'kerbal_connection_state.dart';

enum CONNECTION_STATUS {
  DISCONNECTED,
  CONNECTED,
  ERROR
}

/// [KrappConnBloc] is responsible of sending and receiving data from
/// KSP, through web socket protocol
///
/// Through the web_socket_channel plugin, it establishes a websocket
/// connection to kRPC and provide rpc and stream communication interfaces.
/// See KerbalCommunicator classes for communication interfaces.
class KrappConnBloc extends Bloc<KrappConnEvent, KrappConnState> {
  WebSocketChannel _channel;
  CONNECTION_STATUS _status = CONNECTION_STATUS.DISCONNECTED;

  @override
  KrappConnState get initialState => StatusKrappConnState(_status);

  Uri _getUri(String url, int port, [String name = 'Krapp']) {
    // todo: Make some checks?
    return Uri.parse("ws://" + url + ":" + port.toString() + "/?name=" + name);
  }

  @override
  Stream<KrappConnState> mapEventToState(KrappConnEvent event) async* {

    yield WaitingKrappConnState();

    if (event is StatusKrappConnEvent) {
      yield StatusKrappConnState(_status);

    } else if (event is ConnectKrappConnEvent) {
      Uri uri = _getUri(event.url, event.port, event.name);
      _channel = WebSocketChannel.connect(uri);
      _channel.stream.listen((data) {
        if (data is Uint8List) {
          _status = CONNECTION_STATUS.CONNECTED;
          logD(data.toString());
        }
      }, onError: ((error) {
        logE('RPC stream error: ' + error.toString());
        _status = CONNECTION_STATUS.ERROR;
      }));
      _channel.sink.add(EncodedMessages.getClientIDRequest());

    } else if (event is DisconnectKrappConnEvent) {
      if (_channel != null || _channel.closeCode != null) {
        _channel.sink.close();
      }
      _status = CONNECTION_STATUS.DISCONNECTED;

    } else if (event is RpcRequestKrappConnEvent) {

    } else if (event is StreamSubscriptionKrappConnEvent) {

    }
  }
}
