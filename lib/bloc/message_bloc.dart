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
      emit(MessageFetching(message: "Fecthing Messages"));

      if (LocalStorage.getString("lastdate") == "" ||
          LocalStorage.getString("lastdate") == null) {
        // Create a date that is 120 days before now
        DateTime twoMonthsAgo = DateTime.now().subtract(
          const Duration(days: 60),
        );
        print("Date is null");
        print(twoMonthsAgo.toString());
        await LocalStorage.setString("lastdate", twoMonthsAgo.toString());
      }
      DateTime lastDate = DateTime.parse(
        LocalStorage.getString("lastdate").toString(),
      );

      //DateTime lastDate = DateTime.now().subtract(const Duration(days: 140));
      print("User token is " + LocalStorage.getString("token").toString());
      print("Last date is " + lastDate.toString());

      List<Map<String, dynamic>> messages = await SmsService.fetchSms(lastDate);
      LocalStorage.setString("lastdate", DateTime.now().toString());
      emit(MessageFetching(message: "Storing Messages"));

      emit(MessageFetched());
    });
  }
}
