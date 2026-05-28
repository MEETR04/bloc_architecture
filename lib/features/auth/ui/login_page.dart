import 'package:auto_route/annotations.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_architecture/routes/app_navigator.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/routes/app_routes.gr.dart';
import 'package:bloc_architecture/values/app_spacing.dart';
import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:bloc_architecture/widgets/app_button.dart';
import 'package:bloc_architecture/widgets/app_snackbar.dart';
import 'package:bloc_architecture/widgets/app_textfield.dart';
import 'package:bloc_architecture/widgets/auto_refresh_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<AuthBloc>(
    create: (_) => locator<AuthBloc>(),
    child: Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: AutoRefreshBuilder(
        onRetry: () {
          debugPrint('Retry');
        },
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginFailedState) {
              AppSnackbar.showError(context, message: state.errorMessage);
            }
            if (state is LoginSuccessfulState) {
              AppSnackbar.showSuccess(context, message: state.successMessage);
              AppNavigator.replaceAll([const HomeRoute()]);
            }
          },
          builder: (context, state) {
            final bool isLoading = state is AuthLoadingState;
            return Center(
              child: Padding(
                padding: AppSpacing.symmetricHS16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextField(
                      controller: _emailController,
                      hintText: 'Enter Email',
                      isEmail: true,
                      enabled: !isLoading,
                    ),
                    AppSpacing.vs20,
                    AppTextField(
                      controller: _passwordController,
                      hintText: 'Enter Password',
                      isPassword: true,
                      enabled: !isLoading,
                    ),
                    AppSpacing.vs20,
                    AppButton(
                      text: 'Sign In',
                      isLoading: isLoading,
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          LoginButtonPressedEvent(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                      },
                    ),
                    AppSpacing.vs20,
                    InkWell(
                      onTap: isLoading ? null : () => appRouter.push(const SignUpRoute()),
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: isLoading
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    AppSpacing.vs20,
                    Text(
                      'Use: eve.holt@reqres.in / cityslicka',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
