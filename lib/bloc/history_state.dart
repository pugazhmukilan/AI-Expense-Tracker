import 'package:equatable/equatable.dart';
import 'package:ai_expense/models/yearly_summary_model.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}
class HistoryLoading extends HistoryState {}
class HistoryLoaded extends HistoryState {
  final YearlySummaryModel yearlySummary;
  const HistoryLoaded({required this.yearlySummary});
  @override
  List<Object?> get props => [yearlySummary];
}
class HistoryEmpty extends HistoryState {}
class HistoryError extends HistoryState {
  final String message;
  const HistoryError({required this.message});
  @override
  List<Object?> get props => [message];
}
