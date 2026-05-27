import 'package:auto_route/annotations.dart';
import 'package:bloc_architecture/core/db/app_db.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/routes/app_routes.gr.dart';
import 'package:bloc_architecture/widgets/app_button.dart';
import 'package:bloc_architecture/widgets/app_snackbar.dart';
import 'package:bloc_architecture/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  void initState() {
    super.initState();
    if (appDB.isLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appRouter.replaceAll([const HomeRoute()]);
      });
    }
  }

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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginFailedState) {
            AppSnackbar.showError(context, message: state.errorMessage);
          }
          if (state is LoginSuccessfulState) {
            AppSnackbar.showSuccess(context, message: state.successMessage);
            appRouter.replaceAll([const HomeRoute()]);
          }
        },
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextField(
                    controller: _emailController,
                    hintText: 'Enter Email',
                    isEmail: true,
                  ),
                  20.verticalSpace,
                  AppTextField(
                    controller: _passwordController,
                    hintText: 'Enter Password',
                    isPassword: true,
                  ),
                  20.verticalSpace,
                  AppButton(
                    text: 'Sign In',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginButtonPressedEvent(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    },
                    buttonBgColor: const Color(0xff546565),
                  ),
                  20.verticalSpace,
                  InkWell(
                    onTap: () => appRouter.push(const SignUpRoute()),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
