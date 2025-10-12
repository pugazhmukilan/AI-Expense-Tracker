class MonthlyDetailsModel {
  final int month;
  final int year;
  final String monthName;
  final MonthlyStats monthlyStats;
  final Map<String, CategoryDetails> categoryWiseSummary;
  final List<Transaction> allTransactions;

  MonthlyDetailsModel({
    required this.month,
    required this.year,
    required this.monthName,
    required this.monthlyStats,
    required this.categoryWiseSummary,
    required this.allTransactions,
  });

  factory MonthlyDetailsModel.fromJson(Map<String, dynamic> json) {
    Map<String, CategoryDetails> categories = {};
    if (json['category_wise_summary'] != null) {
      (json['category_wise_summary'] as Map<String, dynamic>).forEach((key, value) {
        categories[key] = CategoryDetails.fromJson(value);
      });
    }

    List<Transaction> transactions = [];
    if (json['all_transactions'] != null) {
      transactions = (json['all_transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList();
    }

    return MonthlyDetailsModel(
      month: json['month'],
      year: json['year'],
      monthName: json['month_name'],
      monthlyStats: MonthlyStats.fromJson(json['monthly_stats']),
      categoryWiseSummary: categories,
      allTransactions: transactions,
    );
  }

  double get totalSpent {
    double total = 0;
    categoryWiseSummary.forEach((key, value) {
      for (var transaction in value.transactions) {
        if (transaction.transactionType == 'debited') {
          total += transaction.amountValue;
        }
      }
    });
    return total;
  }

  String get formattedTotalSpent {
    return '₹${totalSpent.toStringAsFixed(2)}';
  }
}

class MonthlyStats {
  final int totalTransactions;
  final int totalCredited;
  final int totalDebited;
  final double creditedAmount;
  final double debitedAmount;

  MonthlyStats({
    required this.totalTransactions,
    required this.totalCredited,
    required this.totalDebited,
    required this.creditedAmount,
    required this.debitedAmount,
  });

  factory MonthlyStats.fromJson(Map<String, dynamic> json) {
    return MonthlyStats(
      totalTransactions: json['total_transactions'],
      totalCredited: json['total_credited'],
      totalDebited: json['total_debited'],
      creditedAmount: (json['credited_amount'] as num).toDouble(),
      debitedAmount: (json['debited_amount'] as num).toDouble(),
    );
  }
}

class CategoryDetails {
  final int count;
  final List<Transaction> transactions;

  CategoryDetails({
    required this.count,
    required this.transactions,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      count: json['count'],
      transactions: (json['transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList(),
    );
  }

  double get totalAmount {
    return transactions.fold(0, (sum, t) => sum + t.amountValue);
  }

  String get formattedTotalAmount {
    return '₹${totalAmount.toStringAsFixed(2)}';
  }
}

class Transaction {
  final String id;
  final String address;
  final String subject;
  final DateTime date;
  final String transactionType;
  final String amount;
  final String body;
  final String merchant;
  final String category;

  Transaction({
    required this.id,
    required this.address,
    required this.subject,
    required this.date,
    required this.transactionType,
    required this.amount,
    required this.body,
    required this.merchant,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      address: json['address'] ?? '',
      subject: json['subject'] ?? '',
      date: DateTime.parse(json['date']),
      transactionType: json['transaction_type'],
      amount: json['amount'].toString(),
      body: json['body'] ?? '',
      merchant: json['merchant'] ?? '',
      category: json['category'] ?? '',
    );
  }

  double get amountValue {
    String cleanAmount = amount.replaceAll(',', '');
    return double.tryParse(cleanAmount) ?? 0.0;
  }

  String get formattedAmount {
    return '₹$amount';
  }

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}
