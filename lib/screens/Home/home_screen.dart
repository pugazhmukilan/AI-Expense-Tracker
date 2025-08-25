import 'package:ai_expense/screens/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../login_or_sign_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              // After unauth state we want to go to login screen without stacking
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginOrSignScreen()), (route) => false);
            },
          )
        ],
      ),
      body: const Center(child: Text('Home - Blank')),



      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              GestureDetector(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                },
                child:Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:Icon(Icons.account_circle,size: 40,color: Theme.of(context).colorScheme.primary,),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}