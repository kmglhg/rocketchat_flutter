class UserDto {
  UserDto({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.status,
    required this.avatarETag,
  });

  String id;
  String username;
  String name;
  String email;
  String status;
  String avatarETag;

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json["_id"] ?? '',
    username: json["username"] ?? '',
    name: json["name"] ?? '',
    email: json["email"] ?? '',
    status: json["status"] ?? '',
    avatarETag: json["avatarETag"] ?? '',
  );
}