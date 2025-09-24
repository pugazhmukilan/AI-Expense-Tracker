class Loan {
  final String id;
  final String name;
  final DateTime endDate;
  final double amount;

  Loan({
    required this.id,
    required this.name,
    required this.endDate,
    required this.amount,
  });

  // Convert from JSON
  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      endDate: DateTime.parse(json['endDate']),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "endDate": endDate.toIso8601String(),
      "amount": amount,
    };
  }
}
