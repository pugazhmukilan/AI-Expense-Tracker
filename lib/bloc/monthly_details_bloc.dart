import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_expense/bloc/monthly_details_event.dart';
import 'package:ai_expense/bloc/monthly_details_state.dart';
import 'package:ai_expense/repositories/monthly_details_repository.dart';

class MonthlyDetailsBloc extends Bloc<MonthlyDetailsEvent, MonthlyDetailsState> {
  final MonthlyDetailsRepository monthlyDetailsRepository;

  MonthlyDetailsBloc({required this.monthlyDetailsRepository}) : super(MonthlyDetailsInitial()) {
    on<FetchMonthlyDetails>(_onFetchMonthlyDetails);
  }

  Future<void> _onFetchMonthlyDetails(
    FetchMonthlyDetails event,
    Emitter<MonthlyDetailsState> emit,
  ) async {
    emit(MonthlyDetailsLoading());
    try {
      final monthlyDetails = await monthlyDetailsRepository.fetchMonthlyDetails(
        year: event.year,
        month: event.month,
      );
      if (monthlyDetails != null) {
        emit(MonthlyDetailsLoaded(monthlyDetails: monthlyDetails));
      } else {
        emit(MonthlyDetailsEmpty());
      }
    } catch (e) {
      emit(MonthlyDetailsError(message: e.toString()));
    }
  }
}
