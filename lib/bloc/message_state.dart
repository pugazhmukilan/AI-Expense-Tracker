part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();
  
  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}
final class MessageFetching extends MessageState {
  late String message;
  MessageFetching({required this.message});
}
final class MessageFetched extends MessageState {}
