import 'package:ai_expense/models/summary_models.dart';
import 'package:ai_expense/utils/transaction_summary_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spending_event.dart';
part 'spending_state.dart';

class SpendingBloc extends Bloc<SpendingEvent, SpendingState> {
  final TransactionSummaryService _summaryService;

  // The service is now a required parameter.
  // This makes the dependency explicit and clear.
  SpendingBloc({required TransactionSummaryService summaryService})
    : _summaryService = summaryService,
      super(SpendingInitial()) {
    on<FetchMonthlySpending>(_onFetchMonthlySpending);
  }

  // Extracted the logic into a separate method for better organization.
  Future<void> _onFetchMonthlySpending(
    FetchMonthlySpending event,
    Emitter<SpendingState> emit,
  ) async {
    try {
      emit(SpendingLoading());
      final summary = await _summaryService.getMonthlySummary(
        event.month,
        event.year,
      );
      emit(SpendingLoaded(summary));
    } catch (e) {
      // It's often better to pass the actual error object
      emit(SpendingError(e.toString()));
    }
  }
}
