part of 'spendings_bloc.dart';

sealed class SpendingEvent extends Equatable {
  const SpendingEvent();

  @override
  List<Object> get props => [];
}

final class FetchMonthlySpending extends SpendingEvent {
  final int month;
  final int year;

  const FetchMonthlySpending({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}
