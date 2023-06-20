class TodoDto {
  final String title;
  final String description;
  final String? isCompleted;

  const TodoDto(
      {required this.title, required this.description, this.isCompleted});
}
