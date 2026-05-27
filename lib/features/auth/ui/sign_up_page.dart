import 'package:auto_route/annotations.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/routes/app_routes.gr.dart';
import 'package:bloc_architecture/values/app_colors.dart';
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
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
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextField(
                      controller: _firstNameController,
                      hintText: 'Enter First Name',
                      textInputAction: TextInputAction.next,
                    ),
                    10.verticalSpace,
                    AppTextField(
                      controller: _lastNameController,
                      hintText: 'Enter Last Name',
                      textInputAction: TextInputAction.next,
                    ),
                    10.verticalSpace,
                    AppTextField(
                      controller: _phoneNumberController,
                      hintText: 'Enter Phone Number',
                      isPhoneNumber: true,
                      textInputAction: TextInputAction.next,
                    ),
                    10.verticalSpace,
                    AppTextField(
                      controller: _emailController,
                      hintText: 'Enter Email',
                      isEmail: true,
                      textInputAction: TextInputAction.next,
                    ),
                    10.verticalSpace,
                    AppTextField(
                      controller: _passwordController,
                      hintText: 'Enter Password',
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                    ),
                    20.verticalSpace,
                    AppButton(
                      text: 'Sign Up',
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          SignUpButtonPressedEvent(
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            phoneNumber: _phoneNumberController.text.trim(),
                          ),
                        );
                      },
                      buttonBgColor: AppColors.primary,
                      horizontalPadding: 15.w,
                      height: 50.h,
                      buttonRadius: 10.r,
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
