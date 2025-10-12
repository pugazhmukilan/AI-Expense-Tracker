class CategoryDetailsModel {
  final FilterInfo filter;
  final SummaryInfo summary;
  final List<MerchantBreakdown> merchantBreakdown;
  final List<CategoryTransaction> transactions;

  CategoryDetailsModel({
    required this.filter,
    required this.summary,
    required this.merchantBreakdown,
    required this.transactions,
  });

  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailsModel(
      filter: FilterInfo.fromJson(json['filter'] ?? {}),
      summary: SummaryInfo.fromJson(json['summary'] ?? {}),
      merchantBreakdown: (json['merchantBreakdown'] as List? ?? [])
          .map((m) => MerchantBreakdown.fromJson(m))
          .toList(),
      transactions: (json['transactions'] as List? ?? [])
          .map((t) => CategoryTransaction.fromJson(t))
          .toList(),
    );
  }
}

class FilterInfo {
  final String category;
  final int month;
  final int year;
  final String monthName;

  FilterInfo({
    required this.category,
    required this.month,
    required this.year,
    required this.monthName,
  });

  factory FilterInfo.fromJson(Map<String, dynamic> json) {
    return FilterInfo(
      category: json['category'] ?? '',
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      monthName: json['monthName'] ?? '',
    );
  }
}

class SummaryInfo {
  final int totalTransactions;
  final double totalAmount;
  final String formattedTotalAmount;
  final int debitedTransactions;
  final double debitedAmount;
  final String formattedDebitedAmount;
  final int creditedTransactions;
  final double creditedAmount;
  final String formattedCreditedAmount;
  final int uniqueMerchants;

  SummaryInfo({
    required this.totalTransactions,
    required this.totalAmount,
    required this.formattedTotalAmount,
    required this.debitedTransactions,
    required this.debitedAmount,
    required this.formattedDebitedAmount,
    required this.creditedTransactions,
    required this.creditedAmount,
    required this.formattedCreditedAmount,
    required this.uniqueMerchants,
  });

  factory SummaryInfo.fromJson(Map<String, dynamic> json) {
    return SummaryInfo(
      totalTransactions: json['totalTransactions'] ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      formattedTotalAmount: json['formattedTotalAmount'] ?? '₹0.00',
      debitedTransactions: json['debitedTransactions'] ?? 0,
      debitedAmount: (json['debitedAmount'] as num?)?.toDouble() ?? 0.0,
      formattedDebitedAmount: json['formattedDebitedAmount'] ?? '₹0.00',
      creditedTransactions: json['creditedTransactions'] ?? 0,
      creditedAmount: (json['creditedAmount'] as num?)?.toDouble() ?? 0.0,
      formattedCreditedAmount: json['formattedCreditedAmount'] ?? '₹0.00',
      uniqueMerchants: json['uniqueMerchants'] ?? 0,
    );
  }
}

class MerchantBreakdown {
  final String merchant;
  final double totalAmount;
  final String formattedAmount;
  final int transactionCount;
  final double creditedAmount;
  final double debitedAmount;
  final String formattedCreditedAmount;
  final String formattedDebitedAmount;
  final int creditedCount;
  final int debitedCount;
  final List<MerchantTransaction> transactions;

  MerchantBreakdown({
    required this.merchant,
    required this.totalAmount,
    required this.formattedAmount,
    required this.transactionCount,
    required this.creditedAmount,
    required this.debitedAmount,
    required this.formattedCreditedAmount,
    required this.formattedDebitedAmount,
    required this.creditedCount,
    required this.debitedCount,
    required this.transactions,
  });

  factory MerchantBreakdown.fromJson(Map<String, dynamic> json) {
    return MerchantBreakdown(
      merchant: json['merchant'] ?? 'Unknown',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      formattedAmount: json['formattedAmount'] ?? '₹0.00',
      transactionCount: json['transactionCount'] ?? 0,
      creditedAmount: (json['creditedAmount'] as num?)?.toDouble() ?? 0.0,
      debitedAmount: (json['debitedAmount'] as num?)?.toDouble() ?? 0.0,
      formattedCreditedAmount: json['formattedCreditedAmount'] ?? '₹0.00',
      formattedDebitedAmount: json['formattedDebitedAmount'] ?? '₹0.00',
      creditedCount: json['creditedCount'] ?? 0,
      debitedCount: json['debitedCount'] ?? 0,
      transactions: (json['transactions'] as List? ?? [])
          .map((t) => MerchantTransaction.fromJson(t))
          .toList(),
    );
  }
}

class MerchantTransaction {
  final String id;
  final DateTime date;
  final String amount;
  final String address;
  final String body;
  final String transactionType;

  MerchantTransaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.address,
    required this.body,
    required this.transactionType,
  });

  factory MerchantTransaction.fromJson(Map<String, dynamic> json) {
    return MerchantTransaction(
      id: json['id'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      amount: json['amount']?.toString() ?? '0.00',
      address: json['address'] ?? '',
      body: json['body'] ?? '',
      transactionType: json['transaction_type'] ?? 'debited',
    );
  }

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedAmount {
    return '₹$amount';
  }
}

class CategoryTransaction {
  final String id;
  final String merchant;
  final String address;
  final DateTime date;
  final String amount;
  final String transactionType;
  final String body;
  final bool mlProcessed;
  final DateTime createdAt;

  CategoryTransaction({
    required this.id,
    required this.merchant,
    required this.address,
    required this.date,
    required this.amount,
    required this.transactionType,
    required this.body,
    required this.mlProcessed,
    required this.createdAt,
  });

  factory CategoryTransaction.fromJson(Map<String, dynamic> json) {
    return CategoryTransaction(
      id: json['id'] ?? '',
      merchant: json['merchant'] ?? 'Unknown',
      address: json['address'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      amount: json['amount']?.toString() ?? '0.00',
      transactionType: json['transaction_type'] ?? 'debited',
      body: json['body'] ?? '',
      mlProcessed: json['ml_processed'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }
}
