import 'package:ai_expense/models/monthly_details_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeSummaryState extends Equatable {
  const HomeSummaryState();

  @override
  List<Object> get props => [];
}

class HomeSummaryInitial extends HomeSummaryState {}

class HomeSummaryLoading extends HomeSummaryState {}

class HomeSummaryLoaded extends HomeSummaryState {
  final MonthlyDetailsModel monthlyDetails;

  const HomeSummaryLoaded(this.monthlyDetails);

  @override
  List<Object> get props => [monthlyDetails];
}

class HomeSummaryEmpty extends HomeSummaryState {}

class HomeSummaryError extends HomeSummaryState {
  final String message;

  const HomeSummaryError(this.message);

  @override
  List<Object> get props => [message];
}
