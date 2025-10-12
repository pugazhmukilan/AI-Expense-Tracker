// ...existing code...

class YearlySummaryModel {
  final int year;
  final double totalYearlyAmount;
  final int totalYearlyTransactions;
  final String formattedTotalAmount;
  final Map<String, CategorySummaryModel> yearlyCategories;
  final List<MonthlySummaryModel> monthlyBreakdown;

  YearlySummaryModel({
    required this.year,
    required this.totalYearlyAmount,
    required this.totalYearlyTransactions,
    required this.formattedTotalAmount,
    required this.yearlyCategories,
    required this.monthlyBreakdown,
  });

  factory YearlySummaryModel.fromJson(Map<String, dynamic> json) {
    Map<String, CategorySummaryModel> categories = {};
    (json['yearlyCategories'] as Map<String, dynamic>).forEach((key, value) {
      categories[key] = CategorySummaryModel.fromJson(value);
    });
    List<MonthlySummaryModel> monthlySummaries = [];
    for (var item in json['monthlyBreakdown']) {
      monthlySummaries.add(MonthlySummaryModel.fromJson(item));
    }
    return YearlySummaryModel(
      year: json['year'],
      totalYearlyAmount: (json['totalYearlyAmount'] as num).toDouble(),
      totalYearlyTransactions: json['totalYearlyTransactions'],
      formattedTotalAmount: json['formattedTotalAmount'],
      yearlyCategories: categories,
      monthlyBreakdown: monthlySummaries,
    );
  }
}

class CategorySummaryModel {
  final double totalAmount;
  final int transactionCount;
  final String formattedAmount;

  CategorySummaryModel({
    required this.totalAmount,
    required this.transactionCount,
    required this.formattedAmount,
  });

  factory CategorySummaryModel.fromJson(Map<String, dynamic> json) {
    return CategorySummaryModel(
      totalAmount: (json['totalAmount'] as num).toDouble(),
      transactionCount: json['transactionCount'],
      formattedAmount: json['formattedAmount'],
    );
  }
}

class MonthlySummaryModel {
  final int month;
  final int year;
  final String monthName;
  final Map<String, CategorySummaryModel> categories;
  final double totalMonthlyAmount;
  final int totalTransactionCount;
  final String formattedTotalAmount;
  final DateTime lastUpdated;

  MonthlySummaryModel({
    required this.month,
    required this.year,
    required this.monthName,
    required this.categories,
    required this.totalMonthlyAmount,
    required this.totalTransactionCount,
    required this.formattedTotalAmount,
    required this.lastUpdated,
  });

  factory MonthlySummaryModel.fromJson(Map<String, dynamic> json) {
    Map<String, CategorySummaryModel> categories = {};
    (json['categories'] as Map<String, dynamic>).forEach((key, value) {
      categories[key] = CategorySummaryModel.fromJson(value);
    });
    return MonthlySummaryModel(
      month: json['month'],
      year: json['year'],
      monthName: json['monthName'],
      categories: categories,
      totalMonthlyAmount: (json['totalMonthlyAmount'] as num).toDouble(),
      totalTransactionCount: json['totalTransactionCount'],
      formattedTotalAmount: json['formattedTotalAmount'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
