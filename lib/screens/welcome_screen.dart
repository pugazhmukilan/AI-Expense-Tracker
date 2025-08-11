import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
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
                const SizedBox(height: 40),
                Text('Welcome to', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 36)),
                const SizedBox(height: 4),
                Text('Something App', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 36)),
                const Spacer(),
                Text('The Everything app for managing\nYour expense with AI', style: Theme.of(context).textTheme.bodyMedium),
                ElevatedButton(
                  onPressed: () {
                    // Mark first time completed
                    context.read<AuthBloc>().add(CompleteWelcomeEvent());
                  },
                  child: const SizedBox(width: double.infinity, child: Center(child: Text('Next'))),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}