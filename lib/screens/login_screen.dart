import 'package:ai_expense/screens/SignUp/signup_screen.dart';
import 'package:ai_expense/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true; // state variable

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email required';
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? _passValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Password required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

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
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticatedState) {
                  // Navigate to home and clear stack
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
                }

                if (state is AuthFailureState) {
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoadingState && state.action == AuthAction.login;

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 28),
                      Text('Login', style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 16),
                      

                      TextFormField(
                        controller: _passwordCtrl,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: _passValidator,
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(LoginRequested(email: _emailCtrl.text.trim(), password: _passwordCtrl.text));
                                }
                              },
                        child: SizedBox(
                          height: 48,
                          child: Center(
                            child: isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Login'),
                          ),
                        ),
                      ),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Dont have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()),
                              (Route<dynamic> route) => route.isFirst,
                            );
                          },
                          child: const Text(
                            'Signup',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}