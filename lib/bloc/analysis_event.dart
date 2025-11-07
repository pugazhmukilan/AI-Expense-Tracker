abstract class AnalysisEvent {}

/// 1. Triggered on first-time open (POST /generate)
class GenerateAnalysis extends AnalysisEvent {
  final int year;
  final int month;

  GenerateAnalysis({required this.year, required this.month});
}

/// 2. Triggered on frequent open (GET /view)
class FetchAnalysis extends AnalysisEvent {
  final int year;
  final int month;

  FetchAnalysis({required this.year, required this.month});
}

/// 3. Triggered on refresh button (PUT /update)
class UpdateAnalysis extends AnalysisEvent {
  final int year;
  final int month;

  UpdateAnalysis({required this.year, required this.month});
}
