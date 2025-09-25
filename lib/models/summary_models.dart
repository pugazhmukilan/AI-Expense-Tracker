// lib/models/summary_models.dart

class MonthlySummary {
  final int month;
  final int year;
  final String monthName;
  final Map<String, CategorySummary> categories;
  final double totalMonthlyAmount;
  final int totalTransactionCount;
  final String formattedTotalAmount;
  final String lastUpdated;

  MonthlySummary({
    required this.month,
    required this.year,
    required this.monthName,
    required this.categories,
    required this.totalMonthlyAmount,
    required this.totalTransactionCount,
    required this.formattedTotalAmount,
    required this.lastUpdated,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    final categoriesMap = <String, CategorySummary>{};
    (json['categories'] as Map<String, dynamic>?)?.forEach((key, value) {
      categoriesMap[key] = CategorySummary.fromJson(value);
    });

    return MonthlySummary(
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      monthName: json['monthName'] ?? '',
      categories: categoriesMap,
      totalMonthlyAmount: (json['totalMonthlyAmount'] ?? 0).toDouble(),
      totalTransactionCount: json['totalTransactionCount'] ?? 0,
      formattedTotalAmount: json['formattedTotalAmount'] ?? '',
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'monthName': monthName,
      'categories': categories.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'totalMonthlyAmount': totalMonthlyAmount,
      'totalTransactionCount': totalTransactionCount,
      'formattedTotalAmount': formattedTotalAmount,
      'lastUpdated': lastUpdated,
    };
  }
}

class CategorySummary {
  final double totalAmount;
  final int transactionCount;
  final String formattedAmount;

  CategorySummary({
    required this.totalAmount,
    required this.transactionCount,
    required this.formattedAmount,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      transactionCount: json['transactionCount'] ?? 0,
      formattedAmount: json['formattedAmount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'transactionCount': transactionCount,
      'formattedAmount': formattedAmount,
    };
  }
}
