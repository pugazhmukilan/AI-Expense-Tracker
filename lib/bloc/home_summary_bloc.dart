import 'package:ai_expense/bloc/home_summary_event.dart';
import 'package:ai_expense/bloc/home_summary_state.dart';
import 'package:ai_expense/repositories/monthly_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeSummaryBloc extends Bloc<HomeSummaryEvent, HomeSummaryState> {
  final MonthlyDetailsRepository monthlyDetailsRepository;

  HomeSummaryBloc({required this.monthlyDetailsRepository})
      : super(HomeSummaryInitial()) {
    on<FetchHomeSummary>(_onFetchHomeSummary);
  }

  void _onFetchHomeSummary(
      FetchHomeSummary event, Emitter<HomeSummaryState> emit) async {
    emit(HomeSummaryLoading());
    try {
      final monthlyDetails = await monthlyDetailsRepository.fetchMonthlyDetails(
          year: event.year, month: event.month);
      if (monthlyDetails == null || monthlyDetails.allTransactions.isEmpty) {
        emit(HomeSummaryEmpty());
      } else {
        emit(HomeSummaryLoaded(monthlyDetails));
      }
    } catch (e) {
      emit(HomeSummaryError(e.toString()));
    }
  }
}
