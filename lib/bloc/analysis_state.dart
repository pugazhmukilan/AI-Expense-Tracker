import 'package:ai_expense/models/monthly_analysis_model.dart';

abstract class AnalysisState {}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

/// Success state for all 3 events (Generate, Fetch, Update)
class AnalysisFetched extends AnalysisState {
  final MonthlyAnalysisModel analysis;

  AnalysisFetched({required this.analysis});
}

/// Special state if user tries to GET a report that doesn't exist (404)
class AnalysisNotGenerated extends AnalysisState {}

class AnalysisError extends AnalysisState {
  final String message;

  AnalysisError({required this.message});
}
