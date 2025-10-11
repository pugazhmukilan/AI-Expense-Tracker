import 'package:ai_expense/bloc/message_bloc.dart';
import 'package:ai_expense/bloc/report_bloc.dart';
import 'package:ai_expense/bloc/spendings_bloc.dart';
import 'package:ai_expense/repositories/report_repository.dart';
import 'package:ai_expense/utils/transaction_summary_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_or_sign_screen.dart';
import 'screens/Home/home_screen.dart';
import 'theme/app_theme.dart';
import 'utils/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  final authRepo = AuthRepository();
  final reportRepo = ReportRepository();

  runApp(MyApp(authRepo: authRepo, reportRepo: reportRepo));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepo;
  final ReportRepository reportRepo;
  const MyApp({super.key, required this.authRepo, required this.reportRepo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepo: authRepo)..add(AppStarted()),
        ),
        BlocProvider(create: (_) => MessageBloc()..add(FetchMessage())),
        BlocProvider(
          create:
              (_) => SpendingBloc(summaryService: TransactionSummaryService()),
        ),
        BlocProvider(
          create: (_) => ReportBloc(reportRepository: reportRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Modular BLoC Auth',
        theme: AppTheme.lightTheme,
        home: AppEntryPoint(),
      ),
    );
  }
}

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Navigation handled in builder below as well
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitialState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AuthShowWelcomeState) {
            return const WelcomeScreen();
          }

          if (state is AuthAuthenticatedState) {
            return HomeScreen();
          }

          // AuthUnauthenticatedState or errors
          return const LoginOrSignScreen();
        },
      ),
    );
  }
}
