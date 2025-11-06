import 'package:ai_expense/bloc/analysis_event.dart';
import 'package:ai_expense/bloc/analysis_state.dart';
import 'package:ai_expense/repositories/report_repository.dart';
import 'package:bloc/bloc.dart';
// Note: You may need to update the import paths

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final ReportRepository reportRepository;

  AnalysisBloc({required this.reportRepository}) : super(AnalysisInitial()) {
    on<GenerateAnalysis>(_onGenerateAnalysis);
    on<FetchAnalysis>(_onFetchAnalysis);
    on<UpdateAnalysis>(_onUpdateAnalysis);
  }

  // POST /api/analysis/generate
  Future<void> _onGenerateAnalysis(
    GenerateAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final analysis = await reportRepository.generateReport(
        event.year,
        event.month,
      );
      emit(AnalysisFetched(analysis: analysis));
    } catch (e) {
      // If POST fails because it already exists, try to GET it instead
      if (e.toString().toLowerCase().contains('already exists')) {
        add(FetchAnalysis(year: event.year, month: event.month));
      } else {
        emit(AnalysisError(message: e.toString()));
      }
    }
  }

  // GET /api/analysis/view
  Future<void> _onFetchAnalysis(
    FetchAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading());
    try {
      final analysis = await reportRepository.fetchReportByMonth(
        event.year,
        event.month,
      );
      emit(AnalysisFetched(analysis: analysis));
    } catch (e) {
      // Catch the 404 "Not Found" error from the repository
      if (e.toString().contains('404')) {
        emit(AnalysisNotGenerated());
      } else {
        emit(AnalysisError(message: e.toString()));
      }
    }
  }

  // PUT /api/analysis/update
  Future<void> _onUpdateAnalysis(
    UpdateAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(AnalysisLoading()); // You could make a custom 'AnalysisUpdating' state
    try {
      final analysis = await reportRepository.updateReport(
        event.year,
        event.month,
      );
      emit(AnalysisFetched(analysis: analysis));
    } catch (e) {
      emit(AnalysisError(message: e.toString()));
    }
  }
}
