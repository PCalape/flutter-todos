class ExpenseDto {
  final String category;
  final String? description;
  final double amount;

  const ExpenseDto(
      {required this.category, this.description, required this.amount});
}
