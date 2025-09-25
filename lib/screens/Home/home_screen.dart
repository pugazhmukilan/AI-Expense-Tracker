
import 'dart:ffi';
import 'dart:ui';
import 'package:ai_expense/bloc/message_bloc.dart' show MessageBloc, MessageFetched, MessageFetching, MessageState, FetchMessage;
import 'package:ai_expense/screens/budget_screen.dart';
import 'package:ai_expense/screens/login_or_sign_screen.dart' show LoginOrSignScreen;
import 'package:ai_expense/screens/view_budget_screen.dart';
import 'package:ai_expense/theme/app_theme.dart';
import 'package:ai_expense/utils/local_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc.dart';


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
        onTap: _onItemTapped, // no Navigator.push
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.tertiary,
        unselectedItemColor: AppColors.onPrimary,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String UserName = LocalStorage.getString('name') ?? "User";
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg/crystalbg.png'),
          fit: BoxFit.cover,
        ),
      ),
      
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.tertiary,
          child: const Icon(Icons.upload_file,color: AppColors.primary,),
          onPressed: () {
            context.read<MessageBloc>().add(FetchMessage());
          },
          
        
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Hi ${UserName}!!',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(
                        fontFamily: "Poppins",
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back, you\'ve been missed!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: AppColors.primary,
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
            const SizedBox(height: 10),
            BlocBuilder<MessageBloc,MessageState>(builder: (context, state) {
              if(state is MessageFetching){
                return const Center(child: CircularProgressIndicator(color: Colors.green,));
              } else if (state is MessageFetched) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
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
            }),
            const SizedBox(height: 10),
           

            _buildGlassmorphismContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Monthly Expenses',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹ 2,456.70',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildGlassmorphismContainer(
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
                        maxY: 10000,
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 50,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 8,
                                  child: Text(
                                    '₹${value.toInt()}',
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
                                const style = TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                String text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = 'Jan';
                                    break;
                                  case 1:
                                    text = 'Feb';
                                    break;
                                  case 2:
                                    text = 'Mar';
                                    break;
                                  case 3:
                                    text = 'Apr';
                                    break;
                                  case 4:
                                    text = 'May';
                                    break;
                                  case 5:
                                    text = 'Jun';
                                    break;
                                  default:
                                    text = '';
                                    break;
                                }
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 4,
                                  child: Text(text, style: style),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          makeGroupData(0, 3500),
                          makeGroupData(1, 6000),
                          makeGroupData(2, 7500),
                          makeGroupData(3, 4000),
                          makeGroupData(4, 8500),
                          makeGroupData(5, 5500),
                        ],
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '₹${rod.toY.toStringAsFixed(0)}',
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
            ),
            const SizedBox(height: 24),

            ElevatedButton(
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
                side: BorderSide(color: AppColors.onPrimary.withOpacity(0.5)),
              ),
              child: const Text(
                'View Budget Details',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),

            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'jpg', 'png'],
                );

                if (result != null && result.files.isNotEmpty) {
                  final file = result.files.first;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Picked file: ${file.name}")),
                  );
                }
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(16),
                dashPattern: const [8, 4],
                color: AppColors.primary,
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_circle_outline,
                          color: AppColors.primary,
                        ),
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
}

BarChartGroupData makeGroupData(int x, double y) {
  Color barColor;
  switch (x) {
    case 2:
      barColor = AppColors.tertiary;
      break;
    case 5:
      barColor = AppColors.tertiary.withOpacity(0.7);
      break;
    default:
      barColor = AppColors.onPrimary.withOpacity(0.7);
  }
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: barColor,
        width: 18,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
    ],
  );
}
