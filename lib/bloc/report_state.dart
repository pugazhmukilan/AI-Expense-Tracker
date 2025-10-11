import 'package:ai_expense/models/report_model.dart';
import 'package:ai_expense/models/report_details_model.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportFetching extends ReportState {}

class ReportFetched extends ReportState {
  final List<ReportModel> reports;

  ReportFetched({required this.reports});
}

class ReportEmpty extends ReportState {}

class ReportError extends ReportState {
  final String message;

  ReportError({required this.message});
}

// Report Details States
class ReportDetailsFetching extends ReportState {}

class ReportDetailsFetched extends ReportState {
  final ReportDetailsModel reportDetails;

  ReportDetailsFetched({required this.reportDetails});
}

class ReportDetailsError extends ReportState {
  final String message;

  ReportDetailsError({required this.message});
}
