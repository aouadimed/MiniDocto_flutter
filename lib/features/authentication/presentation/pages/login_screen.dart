import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/core/services/app_routes.dart';
import 'package:flutter_user/core/util/shared_pref_module.dart';
import 'package:flutter_user/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_user/features/authentication/presentation/pages/widgets/create_or_have_account_section.dart';
import 'package:flutter_user/features/authentication/presentation/pages/widgets/header_login.dart';
import 'package:flutter_user/features/authentication/presentation/pages/widgets/login_form.dart';
import 'package:flutter_user/global/common_widget/pop_up_msg.dart';
import 'package:flutter_user/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_user/core/services/app_routes.dart' as route;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailTextFieldController;
  late TextEditingController _passwordTextFieldController;

  @override
  void initState() {
    _emailTextFieldController = TextEditingController();
    _passwordTextFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthFailure) {
            // Log failed login attempt
            FirebaseAnalytics.instance.logEvent(
              name: 'login_failed',
              parameters: {
                'error_message': state.message,
                'timestamp': DateTime.now().toIso8601String(),
              },
            );
            showSnackBar(context: context, message: state.message);
          } else if (state is LoginSuccess) {
            // Log successful login
            FirebaseAnalytics.instance.logEvent(
              name: 'login_success',
              parameters: {
                'user_email': state.userModel.email ?? 'unknown',
                'user_role': state.userModel.role ?? 'unknown',
                'timestamp': DateTime.now().toIso8601String(),
              },
            );
            await TokenManager.saveTokens(
              accessToken: state.userModel.token!,
              refreshToken: state.userModel.refreshToken!,
              role: state.userModel.role!,
              email: state.userModel.email!,
            );
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                route.bottomNavigationBar,
                (route) => false,
              );
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) => {},

              child: Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const LoginHeader(text: 'Login to your account'),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 30,
                              horizontal: 20,
                            ),
                            child: LoginForm(
                              formKey: _formKey,
                              emailController: _emailTextFieldController,
                              passwordController: _passwordTextFieldController,
                              loginAction: () => handleLogin(context),
                              isLoading: state is AuthLoading,
                            ),
                          ),
                          InkWell(
                            onTap: () => {},
                            child: Text(
                              "Forgot the password ?",
                              style: TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: CreateOrHaveAccountSection(
                              onTap: () {
                                goToRegister(context);
                              },
                              question: "Don't have an account?",
                              action: "Sign up",
                            ),
                          ),
                        ],
                      ),
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

  void handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Log login attempt
      print('🔥 Firebase: Logging login_attempt event');
    FirebaseAnalytics.instance.logEvent(
      name: 'login_attempt',
      parameters: {
        'email': _emailTextFieldController.text,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ).then((_) {
      print('✅ Firebase: login_attempt event logged successfully');
    }).catchError((error) {
      print('❌ Firebase: Error logging event: $error');
    });
      
      BlocProvider.of<AuthBloc>(context).add(
        LoginEvent(
          email: _emailTextFieldController.text,
          password: _passwordTextFieldController.text,
        ),
      );
    }
  }
  /*
  void goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, navBar);
  }*/

  void goToRegister(BuildContext context) {
    // Log navigation to register screen
    FirebaseAnalytics.instance.logEvent(
      name: 'navigate_to_register',
      parameters: {
        'source': 'login_screen',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    Navigator.pushNamed(context, registerScreen);
  }

}
