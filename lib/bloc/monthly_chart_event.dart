import 'package:equatable/equatable.dart';

abstract class MonthlyChartEvent extends Equatable {
  const MonthlyChartEvent();

  @override
  List<Object> get props => [];
}

/// Event to signal the BLoC to fetch the spending data for the chart.
class FetchMonthlyChartData extends MonthlyChartEvent {}
