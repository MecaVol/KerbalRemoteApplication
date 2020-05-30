import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/model/krapp_data.dart';
import 'package:kerbal_remote_application/proto/encoded_messages.dart';
import 'package:kerbal_remote_application/utils/logger.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'kerbal_connection_event.dart';

part 'kerbal_connection_state.dart';

/// [KrappConnBloc] is responsible of sending and receiving data from
/// KSP, through web socket protocol
///
/// Through the web_socket_channel plugin, it establishes a websocket
/// connection to kRPC and provide rpc and stream communication interfaces.
///
class KrappConnBloc extends Bloc<KrappConnEvent, KrappConnState> {

  WebSocketChannel _rpcChannel;
  WebSocketChannel _streamChannel;

  Stream<KrappData> rpcStream;

  final _krappStreamTransformer = StreamTransformer<Uint8List, KrappData>
    .fromHandlers(
      handleData: (Uint8List data, EventSink<KrappData> sink) {
        sink.add(KrappData(data, null));
      },
      handleError: (error, _, EventSink<KrappData> sink) {
        sink.add(KrappData(null, error.toString()));
      },
      handleDone: (EventSink<KrappData> sink) {
        sink.add(KrappData(null, 'Stream stopped by the kRPC server!'));
      }
  );

  @override
  KrappConnState get initialState => DisconnectedKrappConnState();

  Uri _getUri(String url, int port, [String name = 'Krapp']) {
    // todo: Make some checks?
    return Uri.parse("ws://" + url + ":" + port.toString() + "/?name=" + name);
  }

  @override
  Stream<KrappConnState> mapEventToState(KrappConnEvent event) async* {

    if (event is ConnectKrappConnEvent) {
      yield ConnectingKrappConnState();
      Uri uri = _getUri(event.url, event.port, event.name);
      _rpcChannel = IOWebSocketChannel.connect(uri);
      rpcStream = _rpcChannel.stream.transform(_krappStreamTransformer);
      _rpcChannel.sink.add(EncodedMessages.getClientIDRequest());
      KrappData data = await rpcStream.last;
      if (data.onError) {
        yield ErrorKrappConnState(data.error);
        this.add(DisconnectKrappConnEvent());
      } else {
        yield ConnectedKrappConnState(rpcStream);
      }

    } else if (event is DisconnectKrappConnEvent) {
      if (_rpcChannel != null || _rpcChannel.closeCode != null) {
        _rpcChannel.sink.close();
      }
      if (_streamChannel != null || _streamChannel.closeCode != null) {
        _streamChannel.sink.close();
      }
      _rpcChannel = null;
      yield DisconnectedKrappConnState();

    } else if (event is RpcRequestKrappConnEvent) {
      if (_rpcChannel != null || _rpcChannel.closeCode != null) {
        _rpcChannel.sink.add(event.data);
        KrappData data = await rpcStream.last;
        if (data.onError) {
          yield ErrorKrappConnState(data.error);
          this.add(DisconnectKrappConnEvent());
        } else {
          yield RpcResponseKrappConnState(data.data);
        }
      } else {
        yield ErrorKrappConnState('RPC data sent to a closed connection.');
      }

    } else if (event is StreamSubscriptionKrappConnEvent) {
      // todo: do!
    }
  }
}
