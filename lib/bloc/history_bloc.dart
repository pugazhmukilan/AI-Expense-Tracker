import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_expense/bloc/history_event.dart';
import 'package:ai_expense/bloc/history_state.dart';
import 'package:ai_expense/repositories/history_repository.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;
  HistoryBloc({required this.historyRepository}) : super(HistoryInitial()) {
    on<FetchYearlySummary>(_onFetchYearlySummary);
    on<RefreshYearlySummary>(_onRefreshYearlySummary);
  }

  Future<void> _onFetchYearlySummary(
    FetchYearlySummary event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final yearlySummary = await historyRepository.fetchYearlySummary();
      if (yearlySummary != null) {
        emit(HistoryLoaded(yearlySummary: yearlySummary));
      } else {
        emit(HistoryEmpty());
      }
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }

  Future<void> _onRefreshYearlySummary(
    RefreshYearlySummary event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final yearlySummary = await historyRepository.fetchYearlySummary();
      if (yearlySummary != null) {
        emit(HistoryLoaded(yearlySummary: yearlySummary));
      } else {
        emit(HistoryEmpty());
      }
    } catch (e) {
      emit(HistoryError(message: e.toString()));
    }
  }
}
