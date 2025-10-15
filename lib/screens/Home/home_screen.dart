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

  late final List<Widget> _pages = [const _HomeContent(), const BudgetScreen()];

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

  // This function remains unchanged from your provided code
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
          // Amount Row
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
          // Stat Cards Row - Using Expanded for equal distribution
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Debited',
                  '${monthlyDetails.monthlyStats.totalDebited}',
                  '${summary.totalDebited}',
                  Icons.arrow_upward,
                  AppColors.tertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Credited',
                  '${monthlyDetails.monthlyStats.totalCredited}',
                  '${summary.totalCredited}',
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 80,
        animateColor: true,
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
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginOrSignScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
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
          BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageFetching) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              } else if (state is MessageFetched) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(
                    child: Text(
                      "Message fetched successfully!",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: "Poppins",
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
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

                double maxYValue = state.spendingData
                    .map((d) => d.totalSpent)
                    .reduce(max);

                if (maxYValue < 100) {
                  maxYValue = 100;
                } else {
                  maxYValue *= 1.2;
                }

                return _buildGlassmorphismContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Spending Chart',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
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
                                          color: Colors.white,
                                          fontSize: 10,
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
                                          color: AppColors.onPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
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
                                  return makeGroupData(
                                    index,
                                    dataPoint.totalSpent,
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
                                  return BarTooltipItem(
                                    '${monthData.monthName}\n₹${monthData.totalSpent.toStringAsFixed(0)}',
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
                        builder: (context) => AmountSpendingsScreen(),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewBudgetScreen(),
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
                      'View Budget Details',
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
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'jpg', 'png'],
              );

              if (result != null && result.files.isNotEmpty) {
                final file = result.files.first;
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Picked file: ${file.name}")),
                  );
                }
              }
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(16),
              dashPattern: const [8, 4],
              color: AppColors.primary,
              child: const SizedBox(
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        "Add a bank statement",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
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
}

BarChartGroupData makeGroupData(int x, double y) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: AppColors.tertiary.withOpacity(0.8),
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
