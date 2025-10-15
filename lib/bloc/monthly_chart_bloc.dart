import 'package:ai_expense/bloc/monthly_chart_event.dart';
import 'package:ai_expense/bloc/monthly_chart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/monthly_chart_repository.dart';

class MonthlyChartBloc extends Bloc<MonthlyChartEvent, MonthlyChartState> {
  final MonthlyChartRepository monthlyChartRepository;

  MonthlyChartBloc({required this.monthlyChartRepository})
    : super(MonthlyChartInitial()) {
    on<FetchMonthlyChartData>(_onFetchMonthlyChartData);
  }

  Future<void> _onFetchMonthlyChartData(
    FetchMonthlyChartData event,
    Emitter<MonthlyChartState> emit,
  ) async {
    emit(MonthlyChartLoading());
    try {
      final data = await monthlyChartRepository.fetchLastSixMonthsSpending();
      emit(MonthlyChartLoaded(data));
    } catch (e) {
      emit(MonthlyChartError(e.toString()));
    }
  }
}
