class ReportModel {
  final String id;
  final String month;
  final int year;
  final bool isSeen;
  final DateTime createdAt;
  final Map<String, dynamic>? additionalData; // For future API data

  ReportModel({
    required this.id,
    required this.month,
    required this.year,
    required this.isSeen,
    required this.createdAt,
    this.additionalData,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? json['_id'] ?? '',
      month: json['month'] ?? '',
      year: json['year'] ?? DateTime.now().year,
      isSeen: json['isSeen'] ?? json['is_seen'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
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
      'additionalData': additionalData,
    };
  }

  // Helper to get month number from name
  int getMonthNumber() {
    const months = {
      'January': 1, 'February': 2, 'March': 3, 'April': 4,
      'May': 5, 'June': 6, 'July': 7, 'August': 8,
      'September': 9, 'October': 10, 'November': 11, 'December': 12
    };
    return months[month] ?? 1;
  }
}
