import 'dart:convert';
import 'package:crinity_teamchat/src/commons/utils/date_time_utils.dart';
import 'package:crinity_teamchat/src/screens/room/dto/attachment_dto.dart';

class MessageDto {
  MessageDto({
    required this.id,
    required this.rId,
    this.msg = '',
    required this.ts,
  });

  final String id;
  final String rId;
  final int ts;

  String msg;
  AttachmentDto? attachment;

  String get tsFormat => DateTimeUtils.format(ts);
  String get dateFormat => DateTimeUtils.format(ts, format: 'yyyy.MM.dd');
  String get timeFormat => DateTimeUtils.format(ts, format: 'HH:mm');

  late String name;
  late String uId;
  late bool my;
  bool showDate = true;
  bool showTime = true;

  factory MessageDto.blank() => MessageDto(
    id: '',
    rId: '',
    msg: '',
    ts: 0
  );

  factory MessageDto.fromJson(Map<String, dynamic> json) => MessageDto(
    id: json['_id'] ?? '',
    rId: json['rid'] ?? '',
    msg: json['msg'] ?? '',
    ts: json['ts']['\$date'] ?? 0,
  );

  dynamic toJson() {
    return jsonDecode('{"_id": "$id", "rid": "$rId", "msg": "$msg", "ts": {"\$date": $ts}}');
  }
}
