import 'package:ai_expense/bloc/spendings_bloc.dart'; // <-- Adjust this import
import 'package:ai_expense/models/summary_models.dart'; // <-- Adjust this import
import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmountSpendingsScreen extends StatefulWidget {
  const AmountSpendingsScreen({super.key});

  @override
  State<AmountSpendingsScreen> createState() => _AmountSpendingsScreenState();
}

class _AmountSpendingsScreenState extends State<AmountSpendingsScreen> {
  @override
  void initState() {
    super.initState();
    // Your BLoC logic is unchanged
    context.read<SpendingBloc>().add(
      FetchMonthlySpending(
        month: DateTime.now().month,
        year: DateTime.now().year,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Amount Spent",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // Your BlocBuilder logic is unchanged
      body: BlocBuilder<SpendingBloc, SpendingState>(
        builder: (context, state) {
          if (state is SpendingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SpendingLoaded) {
            // This now returns the new UI
            return _buildContent(state.summary);
          }
          if (state is SpendingError) {
            return Center(child: Text('Failed to load data: ${state.error}'));
          }
          return const Center(child: Text("No data for this month."));
        },
      ),
    );
  }

  // --- THIS IS THE NEW UI ---
  // This method has been completely rewritten to match the AnalysisScreen
  Widget _buildContent(MonthlySummary summary) {
    final categoriesList = summary.categories.entries.toList();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg/crystalbg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- 1. Top Summary Card ---
          // This card is styled like the SummaryCardWidget
          _buildTotalSpentCard(
            context,
            title: '${summary.monthName}, ${summary.year}',
            value: summary.formattedTotalAmount,
            icon: Icons.account_balance_wallet,
            color: AppColors.primary,
          ),
          const SizedBox(height: 20),

          // --- 2. Categories Card ---
          // This card is styled like the white cards on the AnalysisScreen
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _buildCardDecoration(), // Helper for card style
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Title
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // We use a ListView.builder here, but it must NOT be scrollable
                // and must build all its children at once.
                ListView.builder(
                  itemCount: categoriesList.length,
                  shrinkWrap: true, // Makes it fit its content
                  physics:
                      const NeverScrollableScrollPhysics(), // Disables scrolling
                  itemBuilder: (context, index) {
                    final categoryEntry = categoriesList[index];
                    // We re-use your existing buildCategoryRow method!
                    return buildCategoryRow(
                      categoryEntry.key, // Category name
                      categoryEntry.value.formattedAmount, // Formatted amount
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER 1: Card Decoration (from AnalysisScreen) ---
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // --- HELPER 2: Total Spent Card (from AnalysisScreen) ---
  // (This is a copy of the SummaryCardWidget UI)
  Widget _buildTotalSpentCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title, // e.g., "November, 2025"
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    color: Colors.grey.shade600,
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value, // e.g., "₹2,050.00"
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- YOUR EXISTING WIDGETS ---
  // These are kept as-is, and buildCategoryRow is now used
  // by the new _buildContent method.
  Widget buildCategoryRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              amount,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary, // Changed to match your theme
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dottedDivider() {
    // This widget is no longer used in the new layout,
    // but I've left it as requested.
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        const dashSpace = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1,
              color: const Color(0xffCCCCCC),
            );
          }),
        );
      },
    );
  }
}
