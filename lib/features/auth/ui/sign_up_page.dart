import 'package:auto_route/annotations.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/routes/app_routes.gr.dart';
import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:bloc_architecture/widgets/app_button.dart';
import 'package:bloc_architecture/widgets/app_snackbar.dart';
import 'package:bloc_architecture/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SignUpFailedState) {
              AppSnackbar.showError(context, message: state.errorMessage);
            }
            if (state is SignUpSuccessfulState) {
              AppSnackbar.showSuccess(context, message: state.successMessage);
              appRouter.replaceAll([const HomeRoute()]);
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const CircularProgressIndicator();
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextField(
                    controller: _emailController,
                    hintText: 'Enter Email',
                    isEmail: true,
                  ),
                  10.verticalSpace,
                  AppTextField(
                    controller: _passwordController,
                    hintText: 'Enter Password',
                    isPassword: true,
                  ),
                  20.verticalSpace,
                  AppButton(
                    text: 'Sign Up',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        SignUpButtonPressedEvent(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    },
                  ),
                  20.verticalSpace,
                  InkWell(
                    onTap: () => appRouter.replaceAll([const LoginRoute()]),
                    child: Text(
                      'Already have an account? Sign In',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  // Hint for reqres.in predefined emails
                  20.verticalSpace,
                  Text(
                    'Use: eve.holt@reqres.in / pistol',
                    style: AppTextStyle.bodySmall.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
