import 'package:ai_expense/models/report_model.dart';

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
