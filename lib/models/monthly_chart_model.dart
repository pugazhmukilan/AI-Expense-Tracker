class MonthlySpend {
  final int month;
  final int year;
  final double totalSpent;
  final double debitedAmount;
  final double creditedAmount;
  final String monthName;

  MonthlySpend({
    required this.month,
    required this.year,
    required this.totalSpent,
    required this.debitedAmount,
    required this.creditedAmount,
    required this.monthName,
  });

  factory MonthlySpend.fromJson(Map<String, dynamic> json) {
    return MonthlySpend(
      month: json['month'],
      year: json['year'],
      totalSpent: (json['totalAmount'] as num).toDouble(),
      debitedAmount: (json['debitedAmount'] as num).toDouble(),
      creditedAmount: (json['creditedAmount'] as num).toDouble(),
      monthName: json['monthName'],
    );
  }
}
