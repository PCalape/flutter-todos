class ExpenseDto {
  final String category;
  final String description;
  final double amount;

  const ExpenseDto(
      {required this.category,
      required this.description,
      required this.amount});
}
