import 'package:ai_expense/bloc/spendings_bloc.dart'; // <-- Adjust this import to your BLoC path
import 'package:ai_expense/models/summary_models.dart'; // <-- Adjust this import to your models path
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
    // When the screen opens, ask the BLoC to fetch data for the current month and year
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
      // Use BlocBuilder to listen for state changes from the SpendingBloc
      body: BlocBuilder<SpendingBloc, SpendingState>(
        builder: (context, state) {
          // While data is loading, show a loading spinner
          if (state is SpendingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // If data is successfully loaded, build the main content
          if (state is SpendingLoaded) {
            return _buildContent(state.summary);
          }
          // If there was an error, show an error message
          if (state is SpendingError) {
            return Center(child: Text('Failed to load data: ${state.error}'));
          }
          // Default state
          return const Center(child: Text("No data for this month."));
        },
      ),
    );
  }

  // A helper widget to build the main content with the fetched data
  Widget _buildContent(MonthlySummary summary) {
    // Convert the summary's categories map into a list to use in the ListView
    final categoriesList = summary.categories.entries.toList();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg/crystalbg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top card displaying dynamic data
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/bg/Slice.png"),
                  fit: BoxFit.cover,
                ),
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Month",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${summary.monthName}, ${summary.year}',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: AppColors.tertiary,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Total Spent",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            summary.formattedTotalAmount,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: AppColors.tertiary,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Categories",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 32,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: dottedDivider(),
            ),

            // ** THE FIX FOR THE OVERFLOW **
            // Use Expanded and ListView.builder to create a scrollable, dynamic list
            Expanded(
              child: ListView.builder(
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  final categoryEntry = categoriesList[index];
                  // Reuse your buildCategoryRow widget for each item from the API
                  return buildCategoryRow(
                    categoryEntry.key, // Category name
                    categoryEntry.value.formattedAmount, // Formatted amount
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your existing buildCategoryRow and dottedDivider widgets remain unchanged
  Widget buildCategoryRow(String title, String amount) {
    // ... same as before
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontFamily: "Poppins", fontSize: 16),
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
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dottedDivider() {
    // ... same as before
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

