import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          image: DecorationImage(
            image: AssetImage('assets/bg/mainbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text('Welcome to', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 50)),
              
              // Text('Something App', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40)),
              Image.asset("assets/logo/expensio.png",scale:10,),
              const SizedBox(height: 8),
              Text('The Expensio app for managing\nYour expense with AI', style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Mark first time completed
                  context.read<AuthBloc>().add(CompleteWelcomeEvent());
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration:BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    
                  ),
                  child: Center(child: Text("Next", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))),
                )
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}