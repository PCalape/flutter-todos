class UserDto {
  final String email;
  final String name;
  final String? photo;

  const UserDto({required this.email, required this.name, this.photo});
}