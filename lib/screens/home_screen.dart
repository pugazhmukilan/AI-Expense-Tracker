import 'package:ai_expense/screens/login_or_sign_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc.dart';


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
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) =>  LoginOrSignScreen()), (route) => false);
            },
          )
        ],
      ),
      body: const Center(child: Text('Home - Blank')),
    );
  }
}