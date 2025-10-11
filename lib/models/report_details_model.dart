class ReportDetailsModel {
  final String id;
  final String month;
  final int year;
  final bool isSeen;
  final DateTime createdAt;
  final double totalAmount;
  final int totalTransactions;
  final Map<String, double> categoryBreakdown;
  final List<TopExpense> topExpenses;
  final String summary;
  final Map<String, dynamic>? additionalData;

  ReportDetailsModel({
    required this.id,
    required this.month,
    required this.year,
    required this.isSeen,
    required this.createdAt,
    required this.totalAmount,
    required this.totalTransactions,
    required this.categoryBreakdown,
    required this.topExpenses,
    required this.summary,
    this.additionalData,
  });

  factory ReportDetailsModel.fromJson(Map<String, dynamic> json) {
    return ReportDetailsModel(
      id: json['id'] ?? json['_id'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? DateTime.now().year,
      isSeen: json['isSeen'] ?? json['is_seen'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      totalAmount: (json['totalAmount'] ?? json['total_amount'] ?? 0).toDouble(),
      totalTransactions: json['totalTransactions'] ?? json['total_transactions'] ?? 0,
      categoryBreakdown: (json['categoryBreakdown'] ?? json['category_breakdown'] ?? {})
          .map<String, double>((key, value) => MapEntry(key.toString(), (value ?? 0).toDouble())),
      topExpenses: (json['topExpenses'] ?? json['top_expenses'] ?? [])
          .map<TopExpense>((e) => TopExpense.fromJson(e))
          .toList(),
      summary: json['summary'] ?? '',
      additionalData: json['additionalData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month,
      'year': year,
      'isSeen': isSeen,
      'createdAt': createdAt.toIso8601String(),
      'totalAmount': totalAmount,
      'totalTransactions': totalTransactions,
      'categoryBreakdown': categoryBreakdown,
      'topExpenses': topExpenses.map((e) => e.toJson()).toList(),
      'summary': summary,
      'additionalData': additionalData,
    };
  }
}

class TopExpense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final String? merchant;

  TopExpense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.merchant,
  });

  factory TopExpense.fromJson(Map<String, dynamic> json) {
    return TopExpense(
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      category: json['category'] ?? 'Other',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      merchant: json['merchant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'merchant': merchant,
    };
  }
}
