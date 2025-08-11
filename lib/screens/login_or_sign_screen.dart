import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'SignUp/signup_screen.dart';

class LoginOrSignScreen extends StatelessWidget {
  const LoginOrSignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/mainbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //i also wanted to change the color based on the theme
                

                Text('Welcome to', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 36)),
                const SizedBox(height: 4),
                Text('Something App', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 36)),
                const SizedBox(height: 4),
                Text('Signup or Login', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Container(
                  height:60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen())),
                    child: Container(height:60,
                width: double.infinity,
                decoration: BoxDecoration(
                
                   color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),child: Center(child: Text('Signup',style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),))),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child:  Container(height:60,
                width: double.infinity,
                decoration: BoxDecoration(
                
                   color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),child: Center(child: Text('Login',style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}