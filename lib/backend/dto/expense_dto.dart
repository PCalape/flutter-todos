class ExpenseDto {
  final String category;
  final String description;
  final double amount;
  final DateTime expenseDate;

  const ExpenseDto(
      {required this.category,
      required this.description,
      required this.amount,
      required this.expenseDate});
}
