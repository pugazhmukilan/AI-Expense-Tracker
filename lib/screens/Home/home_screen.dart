import 'dart:math'; // NEW IMPORT
import 'dart:ui';
import 'package:ai_expense/bloc/home_summary_bloc.dart';
import 'package:ai_expense/bloc/home_summary_event.dart';
import 'package:ai_expense/bloc/home_summary_state.dart';
import 'package:ai_expense/bloc/message_bloc.dart'
    show
        MessageBloc,
        MessageFetched,
        MessageFetching,
        MessageState,
        FetchMessage;
import 'package:ai_expense/screens/AmountSpendings/amount_spendings.dart';
import 'package:ai_expense/screens/AnalysisReports/analysis_reports_screen.dart';
import 'package:ai_expense/screens/MonthlyAnalysis/monthly_analysis_screen.dart';
import 'package:ai_expense/screens/budget_screen.dart';
import 'package:ai_expense/screens/login_or_sign_screen.dart'
    show LoginOrSignScreen;
import 'package:ai_expense/screens/view_budget_screen.dart';
import 'package:ai_expense/theme/app_theme.dart';
import 'package:ai_expense/utils/local_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../bloc/auth_bloc.dart';
import '../../../bloc/monthly_chart_bloc.dart'; // NEW IMPORT
import '../../../bloc/monthly_chart_event.dart'; // NEW IMPORT
import '../../../bloc/monthly_chart_state.dart'; // NEW IMPORT
import '../../../models/monthly_details_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  DateTime noww = DateTime.now();
  late final List<Widget> _pages = [const _HomeContent(), AmountSpendingsScreen(back:false)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Wallet',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.tertiary,
        unselectedItemColor: AppColors.onPrimary,
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  // Chart view state: 'total', 'debited', 'credited'
  String _chartView = 'total';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Fetch data for the top summary card using HomeSummaryBloc
    context.read<HomeSummaryBloc>().add(
      FetchHomeSummary(month: now.month, year: now.year),
    );
    // NEW: Fetch data for the bar chart
    context.read<MonthlyChartBloc>().add(FetchMonthlyChartData());
  }

  // This function displays the monthly summary card
  Widget _buildMerchantTile(
    TransactionSummary summary,
    dynamic monthlyDetails,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Monthly Summary',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${monthlyDetails.monthlyStats.totalTransactions} txns',
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Amount Row - Shows total debited amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  monthlyDetails.formattedTotalSpent,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'spent',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stat Cards Row - Shows debited and credited amounts from API
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Debited',
                  '${monthlyDetails.monthlyStats.totalDebited}',
                  '${monthlyDetails.totalSpent.toStringAsFixed(2)}',
                  Icons.arrow_upward,
                  AppColors.tertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Credited',
                  '${monthlyDetails.monthlyStats.totalCredited}',
                  '${monthlyDetails.totalCredited.toStringAsFixed(2)}',
                  Icons.arrow_downward,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // This function remains unchanged from your provided code
  Widget _buildStatCard(
    String label,
    String value,
    String amt,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '₹$amt',
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$value transactions',
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userName = LocalStorage.getString('name') ?? "User";
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageFetching) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Fetching messages...'),
                ],
              ),
              backgroundColor: Colors.black87,
              duration: Duration(minutes: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is MessageFetched) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 16),
                  Text('Messages fetched successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          toolbarHeight: 80,
          animateColor: true,
          automaticallyImplyLeading: false,
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
            ),
          ],
          flexibleSpace: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi $userName!!',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(
                            fontFamily: "Poppins",
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Welcome back, you\'ve been missed!',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontFamily: "Poppins",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.tertiary,
        child: const Icon(Icons.upload_file, color: AppColors.primary),
        onPressed: () {
          context.read<MessageBloc>().add(FetchMessage());
          final now = DateTime.now();
          // Refresh home summary using HomeSummaryBloc
          context.read<HomeSummaryBloc>().add(
            FetchHomeSummary(month: now.month, year: now.year),
          );
          context.read<MonthlyChartBloc>().add(
            FetchMonthlyChartData(),
          ); // Refresh chart
        },
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        children: [
          const SizedBox(height: 10),

          // Monthly Summary Card - now using HomeSummaryBloc
          BlocBuilder<HomeSummaryBloc, HomeSummaryState>(
            builder: (context, state) {
              if (state is HomeSummaryLoading) {
                return _buildSkeletonMonthlySummary(); // Replace CircularProgressIndicator
              } else if (state is HomeSummaryLoaded) {
                if (state.monthlyDetails.allTransactions.isEmpty) {
                  return _buildGlassmorphismContainer(
                    child: const Center(
                      child: Text(
                        "No transactions this month.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                }

                // Your logic for the top card
                final allTransactions = state.monthlyDetails.allTransactions;
                final Map<String, List<Transaction>> groupedByMerchant = {};
                for (var transaction in allTransactions) {
                  final merchantName =
                      transaction.merchant.isNotEmpty
                          ? transaction.merchant
                          : 'Unknown';
                  if (groupedByMerchant.containsKey(merchantName)) {
                    groupedByMerchant[merchantName]!.add(transaction);
                  } else {
                    groupedByMerchant[merchantName] = [transaction];
                  }
                }
                final List<TransactionSummary> summaries =
                    groupedByMerchant.entries.map((entry) {
                      double totalDebited = 0;
                      int debitedCount = 0;
                      double totalCredited = 0;
                      int creditedCount = 0;
                      for (var t in entry.value) {
                        if (t.transactionType == 'debited') {
                          totalDebited += t.amountValue;
                          debitedCount++;
                        } else {
                          totalCredited += t.amountValue;
                          creditedCount++;
                        }
                      }
                      return TransactionSummary(
                        merchantName: entry.key,
                        totalDebited: totalDebited,
                        debitedCount: debitedCount,
                        totalCredited: totalCredited,
                        creditedCount: creditedCount,
                        transactionCount: entry.value.length,
                      );
                    }).toList();
                summaries.sort(
                  (a, b) => b.transactionCount.compareTo(a.transactionCount),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                      child: Text(
                        "Transactions",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...summaries
                        .take(1)
                        .map(
                          (summary) =>
                              _buildMerchantTile(summary, state.monthlyDetails),
                        ),
                  ],
                );
              } else if (state is HomeSummaryError) {
                return const Center(child: Text("Error loading transactions."));
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 24),

          // ### THIS IS THE ONLY MODIFIED SECTION ###
          // Dynamic Spending Chart
          BlocBuilder<MonthlyChartBloc, MonthlyChartState>(
            builder: (context, state) {
              if (state is MonthlyChartLoading) {
                return _buildSkeletonChart(); // Replace CircularProgressIndicator
              }

              if (state is MonthlyChartError) {
                return _buildGlassmorphismContainer(
                  child: const SizedBox(
                    height: 250,
                    child: Center(
                      child: Text(
                        "Could not load chart data.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                );
              }

              if (state is MonthlyChartLoaded) {
                if (state.spendingData.isEmpty) {
                  return _buildGlassmorphismContainer(
                    child: const SizedBox(
                      height: 250,
                      child: Center(
                        child: Text(
                          "No spending data for the chart.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  );
                }

                // Calculate maxYValue based on selected view
                double maxYValue;
                switch (_chartView) {
                  case 'debited':
                    maxYValue = state.spendingData
                        .map((d) => d.debitedAmount)
                        .reduce(max);
                    break;
                  case 'credited':
                    maxYValue = state.spendingData
                        .map((d) => d.creditedAmount)
                        .reduce(max);
                    break;
                  case 'total':
                  default:
                    maxYValue = state.spendingData
                        .map((d) => d.totalSpent)
                        .reduce(max);
                }

                if (maxYValue < 100) {
                  maxYValue = 100;
                } else {
                  maxYValue *= 1.2;
                }

                return _buildChartContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chart title
                      const Text(
                        'Transaction Chart',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Toggle buttons - full width with spacing
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildChartToggleButton(
                                'Total',
                                'total',
                                Icons.bar_chart,
                              ),
                              _buildChartToggleButton(
                                'Debited',
                                'debited',
                                Icons.arrow_upward,
                              ),
                              _buildChartToggleButton(
                                'Credited',
                                'credited',
                                Icons.arrow_downward,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxYValue,
                            minY: 0,
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 50,
                                  interval: maxYValue / 4,
                                  getTitlesWidget: (value, meta) {
                                    if (value == 0) return const SizedBox();

                                    String text;
                                    if (value >= 1000) {
                                      text =
                                          '₹${(value / 1000).toStringAsFixed(0)}k';
                                    } else {
                                      text = '₹${value.toStringAsFixed(0)}';
                                    }
                                    return SideTitleWidget(
                                      meta: meta,
                                      space: 8,
                                      child: Text(
                                        text,
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.black87,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 20,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= state.spendingData.length)
                                      return const SizedBox();

                                    // Get the full month name and take the first 3 letters
                                    final String monthName =
                                        state.spendingData[index].monthName;
                                    final String shortMonthName = monthName
                                        .substring(0, 3);

                                    return SideTitleWidget(
                                      meta: meta,
                                      space: 4,
                                      // No angle is needed anymore since the labels are short
                                      child: Text(
                                        shortMonthName, // Use the short name here
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups:
                                state.spendingData.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final dataPoint = entry.value;

                                  // Get the appropriate value and color based on selected view
                                  double barValue;
                                  Color barColor;
                                  switch (_chartView) {
                                    case 'debited':
                                      barValue = dataPoint.debitedAmount;
                                      barColor =
                                          Colors
                                              .red
                                              .shade400; // Red for spending
                                      break;
                                    case 'credited':
                                      barValue = dataPoint.creditedAmount;
                                      barColor = Colors.green.shade400; // Green
                                      break;
                                    case 'total':
                                    default:
                                      barValue = dataPoint.totalSpent;
                                      barColor = AppColors.tertiary.withOpacity(
                                        0.8,
                                      ); // Default
                                  }

                                  return makeGroupData(
                                    index,
                                    barValue,
                                    barColor,
                                  );
                                }).toList(),
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem: (
                                  group,
                                  groupIndex,
                                  rod,
                                  rodIndex,
                                ) {
                                  final monthData =
                                      state.spendingData[group.x.toInt()];

                                  // Get the appropriate label and value based on selected view
                                  String label;
                                  double value;
                                  switch (_chartView) {
                                    case 'debited':
                                      label = 'Debited';
                                      value = monthData.debitedAmount;
                                      break;
                                    case 'credited':
                                      label = 'Credited';
                                      value = monthData.creditedAmount;
                                      break;
                                    case 'total':
                                    default:
                                      label = 'Total';
                                      value = monthData.totalSpent;
                                  }

                                  return BarTooltipItem(
                                    '${monthData.monthName}\n$label: ₹${value.toStringAsFixed(0)}',
                                    const TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 24),

          // Navigation Buttons (Remain the same)
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AmountSpendingsScreen(back:true),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: AppColors.onPrimary.withOpacity(0.5),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'View Amount Spent',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DateTime now = DateTime.now();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MonthlyAnalysisScreen(
                              year: now.year,
                              month: now.month,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: AppColors.onPrimary.withOpacity(0.5),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'View Monthly Analysis',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/history');
            },
            icon: const Icon(Icons.history, color: Colors.white),
            label: const Text(
              'Transaction History',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(color: AppColors.onPrimary.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 16),

          // File Picker (Remains the same)
          // GestureDetector(
          //   onTap: () async {
          //     FilePickerResult? result = await FilePicker.platform.pickFiles(
          //       type: FileType.custom,
          //       allowedExtensions: ['pdf', 'jpg', 'png'],
          //     );

          //     if (result != null && result.files.isNotEmpty) {
          //       final file = result.files.first;
          //       if (mounted) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text("Picked file: ${file.name}")),
          //         );
          //       }
          //     }
          //   },
          //   child: DottedBorder(
          //     borderType: BorderType.RRect,
          //     radius: const Radius.circular(16),
          //     dashPattern: const [8, 4],
          //     color: AppColors.primary,
          //     child: const SizedBox(
          //       height: 100,
          //       width: double.infinity,
          //       child: Center(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Icon(Icons.add_circle_outline, color: AppColors.primary),
          //             SizedBox(width: 8),
          //             Text(
          //               "Add a bank statement",
          //               style: TextStyle(
          //                 fontFamily: "Poppins",
          //                 color: Colors.black,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 24),
        ],
      ),
    ),
    );
  }

  Widget _buildChartToggleButton(String label, String value, IconData icon) {
    final isSelected = _chartView == value;
    return InkWell(
      onTap: () {
        setState(() {
          _chartView = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: "Poppins",
                color: isSelected ? Colors.white : Colors.black54,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGlassmorphismContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.onPrimary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSkeletonMonthlySummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white24,
        highlightColor: Colors.white38,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonChart() {
    return _buildGlassmorphismContainer(
      child: Shimmer.fromColors(
        baseColor: Colors.white24,
        highlightColor: Colors.white38,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    String userName = LocalStorage.getString('name') ?? "User";
    String userEmail = LocalStorage.getString('email') ?? "";

    return Drawer(
      backgroundColor: AppColors.primary,
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.tertiary,
                  AppColors.tertiary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Logout Option
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white, size: 26),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginOrSignScreen()),
                (route) => false,
              );
            },
          ),
          const Divider(
            color: Colors.white24,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          // Delete Account Option
          ListTile(
            leading: const Icon(
              Icons.delete_forever,
              color: Colors.redAccent,
              size: 26,
            ),
            title: const Text(
              'Delete Account',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    // Capture the AuthBloc before showing the dialog
    final authBloc = context.read<AuthBloc>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Delete Account',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                // Delete account using the captured authBloc
                authBloc.add(DeleteAccountRequested());
                // Navigate to login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginOrSignScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

BarChartGroupData makeGroupData(int x, double y, Color color) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: color,
        width: 18,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
    ],
  );
}

// This class is here based on your provided code but is not used to build the main UI list anymore.
class TransactionSummary {
  final String merchantName;
  final double totalDebited;
  final int debitedCount;
  final double totalCredited;
  final int creditedCount;
  final int transactionCount;

  TransactionSummary({
    required this.merchantName,
    required this.totalDebited,
    required this.debitedCount,
    required this.totalCredited,
    required this.creditedCount,
    required this.transactionCount,
  });

  String get formattedDebitedAmount {
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return format.format(totalDebited);
  }

  String get formattedCreditedAmount {
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return format.format(totalCredited);
  }
}
