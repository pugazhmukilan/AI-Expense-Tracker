class MonthlySpend {
  final int month;
  final int year;
  final double totalSpent; // Keep this name for consistency in your app
  final String monthName;

  MonthlySpend({
    required this.month,
    required this.year,
    required this.totalSpent,
    required this.monthName,
  });

  // This is the part that needs to change
  factory MonthlySpend.fromJson(Map<String, dynamic> json) {
    return MonthlySpend(
      month: json['month'],
      year: json['year'],
      // Use the correct key from the JSON: 'totalAmount'
      totalSpent: (json['totalAmount'] as num).toDouble(),
      // Use the correct key from the JSON: 'monthName'
      monthName: json['monthName'],
    );
  }
}
