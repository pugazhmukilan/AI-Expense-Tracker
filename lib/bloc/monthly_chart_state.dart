import 'package:ai_expense/models/monthly_chart_model.dart';
import 'package:equatable/equatable.dart';

abstract class MonthlyChartState extends Equatable {
  const MonthlyChartState();

  @override
  List<Object> get props => [];
}

/// The initial state before any action has been taken.
class MonthlyChartInitial extends MonthlyChartState {}

/// The state while the data is being fetched from the API.
class MonthlyChartLoading extends MonthlyChartState {}

/// The state when the data has been successfully fetched.
class MonthlyChartLoaded extends MonthlyChartState {
  final List<MonthlySpend> spendingData;

  const MonthlyChartLoaded(this.spendingData);

  @override
  List<Object> get props => [spendingData];
}

/// The state when an error occurred during the data fetching.
class MonthlyChartError extends MonthlyChartState {
  final String message;

  const MonthlyChartError(this.message);

  @override
  List<Object> get props => [message];
}
