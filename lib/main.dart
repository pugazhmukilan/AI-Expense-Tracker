import 'package:ai_expense/bloc/message_bloc.dart';
import 'package:ai_expense/bloc/monthly_chart_bloc.dart';
import 'package:ai_expense/bloc/report_bloc.dart';
import 'package:ai_expense/bloc/spendings_bloc.dart';
import 'package:ai_expense/repositories/report_repository.dart';
import 'package:ai_expense/repositories/history_repository.dart';
import 'package:ai_expense/repositories/monthly_details_repository.dart';
import 'package:ai_expense/bloc/history_bloc.dart';
import 'package:ai_expense/bloc/monthly_details_bloc.dart';
import 'package:ai_expense/screens/History/history_screen.dart';
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
import 'package:ai_expense/repositories/monthly_chart_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  final authRepo = AuthRepository();
  final reportRepo = ReportRepository();
  final historyRepo = HistoryRepository();
  final monthlyDetailsRepo = MonthlyDetailsRepository();
  final monthlyChartRepo = MonthlyChartRepository();

  runApp(
    MyApp(
      authRepo: authRepo,
      reportRepo: reportRepo,
      historyRepo: historyRepo,
      monthlyDetailsRepo: monthlyDetailsRepo,
      monthlyChartRepo: monthlyChartRepo,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepo;
  final ReportRepository reportRepo;
  final HistoryRepository historyRepo;
  final MonthlyDetailsRepository monthlyDetailsRepo;
  final MonthlyChartRepository monthlyChartRepo;

  const MyApp({
    super.key,
    required this.authRepo,
    required this.reportRepo,
    required this.historyRepo,
    required this.monthlyDetailsRepo,
    required this.monthlyChartRepo,
  });

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
        BlocProvider(create: (_) => ReportBloc(reportRepository: reportRepo)),
        BlocProvider(
          create: (_) => HistoryBloc(historyRepository: historyRepo),
        ),
        BlocProvider(
          create:
              (_) => MonthlyDetailsBloc(
                monthlyDetailsRepository: monthlyDetailsRepo,
              ),
        ),
        BlocProvider(
          create:
              (_) => MonthlyChartBloc(monthlyChartRepository: monthlyChartRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Modular BLoC Auth',
        theme: AppTheme.lightTheme,
        home: AppEntryPoint(),
        routes: {'/history': (context) => const HistoryScreen()},
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
