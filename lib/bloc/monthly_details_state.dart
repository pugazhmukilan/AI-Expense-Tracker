import 'package:equatable/equatable.dart';
import 'package:ai_expense/models/monthly_details_model.dart';

abstract class MonthlyDetailsState extends Equatable {
  const MonthlyDetailsState();
  @override
  List<Object?> get props => [];
}

class MonthlyDetailsInitial extends MonthlyDetailsState {}

class MonthlyDetailsLoading extends MonthlyDetailsState {}

class MonthlyDetailsLoaded extends MonthlyDetailsState {
  final MonthlyDetailsModel monthlyDetails;

  const MonthlyDetailsLoaded({required this.monthlyDetails});

  @override
  List<Object?> get props => [monthlyDetails];
}

class MonthlyDetailsEmpty extends MonthlyDetailsState {}

class MonthlyDetailsError extends MonthlyDetailsState {
  final String message;

  const MonthlyDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
