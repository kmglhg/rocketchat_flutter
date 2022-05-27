import 'package:web_socket_channel/io.dart';
import 'package:crinity_teamchat/src/constants.dart';

class WebSocket {
  static final WebSocket _instance = WebSocket._init();

  factory WebSocket() => _instance;

  late IOWebSocketChannel channel;

  WebSocket._init() {
    connect();
  }

  // 소켓 접속
  connect() {
    channel = IOWebSocketChannel.connect(WEBSOCKET_URL);
  }

  // 소켓 접속 종료
  Future close() async {
    channel.sink.close();
  }

  // 소켓 메시지 발송
  void send(message) {
    channel.sink.add(message);
  }
}
