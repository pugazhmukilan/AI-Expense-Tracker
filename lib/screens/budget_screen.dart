import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const Center(
          child: Text(
            "Plan Budget",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/crystalbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontFamily: "Poppins",
              color: Colors.black,
              fontSize: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Month",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "August,2024", // maek dynamic
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: AppColors.tertiary,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  "Budget Planned",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "₹40,500", // make this dynamic later
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: AppColors.tertiary,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                      //fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: dottedDivider(),
                  ),

                  buildCategoryRow("Shelter", "₹12000"),
                  buildCategoryRow("Dining", "₹5000"),
                  buildCategoryRow("Investment", "₹12000"),
                  buildCategoryRow("Groceries", "₹5000"),
                  buildCategoryRow("Shelter", "₹12000"),
                  buildCategoryRow("Dining", "₹5000"),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: dottedDivider(),
                  ),

                  SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Center(
                      child: Text(
                        "SET BUDGET",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          //fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontFamily: "Poppins", fontSize: 16),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController _controller = TextEditingController(
                        text: amount,
                      );
                      return AlertDialog(
                        title: Text(
                          'Edit $title Budget',
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            labelText: 'Amount',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle save logic here
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xffFFA45F),
                  child: Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dottedDivider() {
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
