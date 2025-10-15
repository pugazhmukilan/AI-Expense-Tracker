import 'package:equatable/equatable.dart';

abstract class HomeSummaryEvent extends Equatable {
  const HomeSummaryEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeSummary extends HomeSummaryEvent {
  final int month;
  final int year;

  const FetchHomeSummary({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];
}
