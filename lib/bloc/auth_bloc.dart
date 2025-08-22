import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/auth_repository.dart';
import '../utils/local_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;

  AuthBloc({required this.authRepo}) : super(AuthInitialState()) {
    on<AppStarted>(_onAppStarted);
    on<CompleteWelcomeEvent>(_onCompleteWelcome);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    // Show splash while checking
    emit(AuthInitialState());

    final bool? firstTime = LocalStorage.getBool('firstTimeUser');
    if (firstTime == null || firstTime == true) {
      // Show welcome
      emit(AuthShowWelcomeState());
      return;
    }

    // not first time - check token
    final token = LocalStorage.getString('authToken');
    if (token != null && token.isNotEmpty) {
      emit(AuthAuthenticatedState(token: token));//if we dont have aauth token in the shared prefderence  then it should go to lgin page

      return;
    }

    emit(AuthUnauthenticatedState());//if it has authenticated token then it should go to home page
  }

  Future<void> _onCompleteWelcome(CompleteWelcomeEvent event, Emitter<AuthState> emit) async {
    await LocalStorage.setBool('firstTimeUser', false);
    emit(AuthUnauthenticatedState());
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState(action: AuthAction.login));
    try {
      final token = await authRepo.login(event.email, event.password);
      await LocalStorage.setString('authToken', token[0]);
      await LocalStorage.setString('name', token[1]);
      await LocalStorage.setString('email', token[2]);
      emit(AuthAuthenticatedState(token: token[0]));
    } catch (e) {
      print(e.toString());
      emit(AuthFailureState(message: e.toString()));
      emit(AuthUnauthenticatedState());
    }
  }

  Future<void> _onSignupRequested(SignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState(action: AuthAction.signup));
    try {
      final token = await authRepo.signup(event.name, event.email, event.password);
      await LocalStorage.setString('authToken', token[0]);
      await LocalStorage.setString('name', token[1]);
      await LocalStorage.setString('email', token[2]);
      emit(AuthAuthenticatedState(token: token[0]));
    } catch (e) {
      emit(AuthFailureState(message: e.toString()));
      emit(AuthUnauthenticatedState());
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState(action: AuthAction.logout));
    await LocalStorage.remove('authToken');
    // After logout go to LoginOrSign
    emit(AuthUnauthenticatedState());
  }
}



//print all the information in the 