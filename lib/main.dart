import 'package:ai_expense/bloc/home_summary_bloc.dart';
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
import 'bloc/auth_bloc.dart'; // Assuming AuthEvent is here
import 'repositories/auth_repository.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_or_sign_screen.dart';
import 'screens/Home/home_screen.dart';
import 'theme/app_theme.dart';
import 'utils/local_storage.dart';
import 'package:ai_expense/repositories/monthly_chart_repository.dart';

// Import Provider package (it's part of flutter_bloc)
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  // Repositories will now be instantiated inside MyApp's providers
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- CHANGE 1: Use MultiProvider instead of MultiBlocProvider ---
    // This allows us to provide *both* Repositories and BLoCs.
    return MultiProvider(
      providers: [
        // --- CHANGE 2: Provide your Repositories here ---
        // This makes them available to 'context.read<T>()' anywhere
        // in your app, which is what AnalysisBloc needs.
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        Provider<ReportRepository>(create: (_) => ReportRepository()),
        Provider<HistoryRepository>(create: (_) => HistoryRepository()),
        Provider<MonthlyDetailsRepository>(
          create: (_) => MonthlyDetailsRepository(),
        ),
        Provider<MonthlyChartRepository>(
          create: (_) => MonthlyChartRepository(),
        ),
        Provider<TransactionSummaryService>(
          create: (_) => TransactionSummaryService(),
        ),

        // --- CHANGE 3: Update BlocProviders to *read* from context ---
        // Your BLoCs can now find their repository dependencies
        // using context.read<T>()
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(authRepo: context.read<AuthRepository>())
                    ..add(AppStarted()),
        ),
        BlocProvider(create: (_) => MessageBloc()..add(FetchMessage())),
        BlocProvider(
          create:
              (context) => SpendingBloc(
                summaryService: context.read<TransactionSummaryService>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => ReportBloc(
                reportRepository: context.read<ReportRepository>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => HistoryBloc(
                historyRepository: context.read<HistoryRepository>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => MonthlyDetailsBloc(
                monthlyDetailsRepository:
                    context.read<MonthlyDetailsRepository>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => MonthlyChartBloc(
                monthlyChartRepository: context.read<MonthlyChartRepository>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => HomeSummaryBloc(
                monthlyDetailsRepository:
                    context.read<MonthlyDetailsRepository>(),
              ),
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
