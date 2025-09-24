import 'package:ai_expense/utils/MessageFetcher.dart';
import 'package:ai_expense/utils/local_storage.dart';
import 'package:another_telephony/telephony.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<FetchMessage>((event, emit) async{
      // TODO: implement event handler
      emit(MessageFetching());
      print("getting the date from the shared preference ");
      if(LocalStorage.getString("lastdate") == "" || LocalStorage.getString("lastdate") == null){
        print("insde the if statement");
        await LocalStorage.setString("lastdate", DateTime.now().toString());
      }
      DateTime lastDate = DateTime.parse(LocalStorage.getString("lastdate").toString());
     
      lastDate = DateTime.parse("2025-09-24 00:00:00.000");
       print("laste date is ==================================="+ lastDate.toString());

      List<Map<String,dynamic>> messages = await SmsService.fetchSms(lastDate);
      LocalStorage.setString("lastdate", DateTime.now().toString());

      print("======================================");
      for(var msg in messages){
        print("body "+msg['body']);
        print("address "+msg['address']);
        print("date "+msg['date']);
       
        print("transaction type "+msg['transaction_type']);
        print("amount "+msg['amount']);

      }
      print("======================================");



      emit(MessageFetched());
    });
  }
}
