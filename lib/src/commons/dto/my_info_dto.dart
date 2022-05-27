class MyInfoDto {
  MyInfoDto({
    required this.id,
    required this.username,
    required this.sidebarShowUnread,
    required this.sidebarShowFavorites,
    required this.sidebarGroupByType,
    required this.sidebarSortby,
  });

  String id;

  String username;

  // 미확인
  bool sidebarShowUnread = false;

  // 즐겨찾기
  bool sidebarShowFavorites = false;

  // 방 타입
  bool sidebarGroupByType = false;

  // 정렬 활동순/이름순 (activity/alphabetical)
  String sidebarSortby = 'activity';
  bool get sidebarSortbyActivity => sidebarSortby == 'activity';

  factory MyInfoDto.fromJson(Map<String, dynamic> json) => MyInfoDto(
    id: json['_id'],
    username: json['username'],
    sidebarShowUnread: json['settings']['preferences']['sidebarShowUnread'],
    sidebarShowFavorites: json['settings']['preferences']['sidebarShowFavorites'],
    sidebarGroupByType: json['settings']['preferences']['sidebarGroupByType'],
    sidebarSortby: json['settings']['preferences']['sidebarSortby'],
  );
}