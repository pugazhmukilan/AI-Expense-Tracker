import 'package:equatable/equatable.dart';

abstract class MonthlyDetailsEvent extends Equatable {
  const MonthlyDetailsEvent();
  @override
  List<Object?> get props => [];
}

class FetchMonthlyDetails extends MonthlyDetailsEvent {
  final int month;
  final int year;

  const FetchMonthlyDetails({required this.month, required this.year});

  @override
  List<Object?> get props => [month, year];
}
