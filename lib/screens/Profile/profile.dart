import 'package:ai_expense/repositories/LoanManager/loanmanager.dart';
import 'package:ai_expense/screens/Profile/informationbox.dart';
import 'package:ai_expense/screens/Profile/profileimage.dart';
import 'package:ai_expense/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:ai_expense/theme/app_theme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool ischanged = false;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.background,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.background),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserInfoWidget(),

            const SizedBox(height: 20),
            const Text(
              "Loans and EMI's",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // TODO: Add Loans/EMIs screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Center(
                child: Text(
                  "Add Loans and EMI's",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Expanded so ListView takes remaining space
            Expanded(
              child: ListView.builder(
                  itemCount: LoanManager.loans.length,
                  itemBuilder: (context, index) {
                    final loan = LoanManager.loans[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left side (title + subtitle)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loan.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "End Date: ${loan.endDate.day}/${loan.endDate.month}/${loan.endDate.year}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right side (amount + delete button)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${loan.amount.toStringAsFixed(0)}/-",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        ischanged = true;
                                        LoanManager.loans.removeAt(index);
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.tertiary,
                                      radius: 16,
                                      child: Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )

                    );
                  },
                ),
            ),
          ],
        ),
      ),



      bottomNavigationBar: BottomAppBar(
        color:ischanged?AppColors.primary:Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              GestureDetector(
                onTap:(){
                //call save finction in the bloc

                },
                child:Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:Text("Save",style: TextStyle(fontSize: 20,color:Colors.white),
                )
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: const [
          ProfileImage(),
          InformationBox(),
        ],
      ),
    );
  }
}




