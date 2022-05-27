import 'dart:convert';
import 'package:crinity_teamchat/src/commons/utils/date_time_utils.dart';

enum AttachmentType { image, file }

class AttachmentDto {
  AttachmentDto({
    required this.title,
    required this.link,
    required this.type,
    required this.description,
  });

  final String title;
  final String link;
  final AttachmentType type;
  final String description;

  factory AttachmentDto.fromJson(Map<String, dynamic> json) => AttachmentDto(
    title: json['title'],
    link: json['title_link'],
    type: json['image_type'] != null ? AttachmentType.image : AttachmentType.file,
    description: json['description'] ?? '',
  );
}
