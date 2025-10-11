import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_expense/bloc/report_event.dart';
import 'package:ai_expense/bloc/report_state.dart';
import 'package:ai_expense/repositories/report_repository.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository reportRepository;

  ReportBloc({required this.reportRepository}) : super(ReportInitial()) {
    on<FetchReports>(_onFetchReports);
  }

  Future<void> _onFetchReports(
    FetchReports event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportFetching());
    
    try {
      final reports = await reportRepository.fetchReports();
      
      if (reports.isEmpty) {
        emit(ReportEmpty());
      } else {
        emit(ReportFetched(reports: reports));
      }
    } catch (e) {
      emit(ReportError(message: e.toString()));
    }
  }
}
