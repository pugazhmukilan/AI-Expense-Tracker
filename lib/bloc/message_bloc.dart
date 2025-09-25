import 'package:ai_expense/utils/MessageFetcher.dart';
import 'package:ai_expense/utils/local_storage.dart';
import 'package:another_telephony/telephony.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<FetchMessage>((event, emit) async {
      // TODO: implement event handler
      emit(MessageFetching(message:"Fecthing Messages"));
     
      if(LocalStorage.getString("lastdate") == "" || LocalStorage.getString("lastdate") == null){
          await LocalStorage.setString("lastdate", DateTime.now().toString());
      }
      DateTime lastDate = DateTime.parse(LocalStorage.getString("lastdate").toString());
     
      

      List<Map<String,dynamic>> messages = await SmsService.fetchSms(lastDate);
      LocalStorage.setString("lastdate", DateTime.now().toString());
       emit(MessageFetching(message:"Storing Messages"));




      emit(MessageFetched());
   
    });
  }
}
