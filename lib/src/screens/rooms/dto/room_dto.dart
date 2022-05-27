import 'package:crinity_teamchat/src/commons/utils/date_time_utils.dart';

enum NodeType {room, unread, favorites, team, channel, direct}

var nodeName = {
  NodeType.unread: '미확인',
  NodeType.favorites: '즐겨찾기',
  NodeType.team: '팀',
  NodeType.channel: '채널',
  NodeType.direct: '개인 대화방',
};

class RoomDto {
  RoomDto({
    required this.nodeType,
    required this.id,
    required this.name,
    required this.type,
    required this.lm,
  });

  final NodeType nodeType;

  final String id;
  String name;
  final String type;
  late Type roomType;
  int lm = 0;

  String lastMessage = '';
  int unread = 0;

  bool alert = false;
  bool open = true;
  bool f = false;
  bool team = false;

  String get lmFormat => DateTimeUtils.format(lm);

  factory RoomDto.node(node) => RoomDto(
    nodeType: node,
    id: '',
    name: '',
    type: '',
    lm: 0,
  );

  factory RoomDto.fromJson(Map<String, dynamic> json) => RoomDto(
    nodeType: NodeType.room,
    id: json['_id'],
    name: json['name'] ?? '',
    type: json['t'],
    lm: json['lm']['\$date'],
  );
}
