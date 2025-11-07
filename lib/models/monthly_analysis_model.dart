class MonthlyAnalysisModel {
  final int month;
  final int year;
  final double totalAmount;
  final double creditedAmount;
  final double debitedAmount;
  final int totalTransactions;
  final Map<String, double> categoryBreakdown;
  final String summary;
  final List<String> suggestions;
  final bool mlProcessed;
  final DateTime mlProcessedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  MonthlyAnalysisModel({
    required this.month,
    required this.year,
    required this.totalAmount,
    required this.creditedAmount,
    required this.debitedAmount,
    required this.totalTransactions,
    required this.categoryBreakdown,
    required this.summary,
    required this.suggestions,
    required this.mlProcessed,
    required this.mlProcessedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MonthlyAnalysisModel.fromJson(Map<String, dynamic> json) {
    // --- THIS IS THE FIX ---
    // We first create a new, correctly-typed map
    // from the (dynamic) 'categoryBreakdown' field.
    final categoryMap = Map<String, dynamic>.from(
      json['categoryBreakdown'] ?? {},
    );

    return MonthlyAnalysisModel(
      month: json['month'] ?? 1,
      year: json['year'] ?? DateTime.now().year,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      creditedAmount: (json['creditedAmount'] ?? 0).toDouble(),
      debitedAmount: (json['debitedAmount'] ?? 0).toDouble(),
      totalTransactions: json['totalTransactions'] ?? 0,

      // Now, we call .map() on our new, safe 'categoryMap'
      categoryBreakdown: categoryMap.map<String, double>(
        (key, value) => MapEntry(key, (value ?? 0).toDouble()),
      ),

      summary: json['summary'] ?? '',
      suggestions: List<String>.from(json['suggestions'] ?? []),
      mlProcessed: json['ml_processed'] ?? false,
      mlProcessedAt: DateTime.parse(json['ml_processed_at']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
