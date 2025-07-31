import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_user/features/authentication/presentation/pages/widgets/create_or_have_account_section.dart';
import 'package:flutter_user/features/authentication/presentation/pages/widgets/header_login.dart';
import 'package:flutter_user/features/authentication/presentation/pages/widgets/register_form.dart';
import 'package:flutter_user/global/common_widget/pop_up_msg.dart';
import 'package:flutter_user/injection_container.dart';
import 'package:flutter_user/core/services/app_routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameTextFieldController;
  late TextEditingController _emailTextFieldController;
  late TextEditingController _passwordTextFieldController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _emailTextFieldController = TextEditingController();
    _passwordTextFieldController = TextEditingController();
    _usernameTextFieldController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    _usernameTextFieldController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            // Log registration failure
            FirebaseAnalytics.instance.logEvent(
              name: 'registration_failed',
              parameters: {
                'error_message': state.message,
                'timestamp': DateTime.now().toIso8601String(),
              },
            );
            showSnackBar(context: context, message: state.message);
          } else if (state is RegisterSuccess) {
            // Log successful registration
            FirebaseAnalytics.instance.logEvent(
              name: 'registration_success',
              parameters: {
                'username': _usernameTextFieldController.text,
                'email': _emailTextFieldController.text,
                'timestamp': DateTime.now().toIso8601String(),
              },
            );
            showSnackBar(
              context: context,
              backgroundColor: greenColor,
              message: 'Registration successful! Please login.',
            );
            Navigator.pushReplacementNamed(context, loginScreen);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: SingleChildScrollView(
                    reverse: false,
                    child: Column(
                      children: [
                        const LoginHeader(text: 'Create New Account'),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 20,
                          ),
                          child: RegisterForm(
                            formKey: _formKey,
                            emailController: _emailTextFieldController,
                            passwordController: _passwordTextFieldController,
                            usernameController: _usernameTextFieldController,
                            registerAction: () => finshProfil(context),
                            confirmPasswordController:
                                _confirmPasswordController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: CreateOrHaveAccountSection(
                            onTap: () {
                              goBackToLogin(context);
                            },
                            question: "Already have an account?",
                            action: "Sign in",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void goBackToLogin(BuildContext context) {
    // Log navigation back to login
    FirebaseAnalytics.instance.logEvent(
      name: 'navigate_to_login',
      parameters: {
        'source': 'register_screen',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    Navigator.pop(context);
  }

  void finshProfil(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Log registration attempt
      FirebaseAnalytics.instance.logEvent(
        name: 'registration_attempt',
        parameters: {
          'username': _usernameTextFieldController.text,
          'email': _emailTextFieldController.text,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      
      BlocProvider.of<AuthBloc>(context).add(
        RegisterEvent(
          name: _usernameTextFieldController.text,
          email: _emailTextFieldController.text,
          password: _passwordTextFieldController.text,
        ),
      );
    }
  }
}
