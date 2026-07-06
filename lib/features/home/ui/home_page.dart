import 'package:auto_route/annotations.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/home/bloc/home_bloc.dart';
import 'package:bloc_architecture/values/app_constants.dart';
import 'package:bloc_architecture/values/app_spacing.dart';
import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:bloc_architecture/widgets/app_dropdown_textfield.dart';
import 'package:bloc_architecture/widgets/app_list_view.dart';
import 'package:bloc_architecture/widgets/app_refresh_indicator.dart';
import 'package:bloc_architecture/widgets/auto_refresh_builder.dart';
import 'package:bloc_architecture/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _sortController = TextEditingController(text: AppConstants.sortAZ);
  final _sortNotifier = ValueNotifier<String>(AppConstants.sortAZ);

  @override
  void dispose() {
    _sortController.dispose();
    _sortNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<HomeBloc>(
    create: (_) => locator<HomeBloc>()..add(FetchUsersEvent()),
    child: Builder(
      builder: (context) => BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is UserListLoadedState) {
            final expectedValue =
                state.isAscending ? AppConstants.sortAZ : AppConstants.sortZA;
            if (_sortNotifier.value != expectedValue) {
              _sortNotifier.value = expectedValue;
              _sortController.text = expectedValue;
            }
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Users',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(56.h),
              child: Padding(
                padding: AppSpacing.symmetricHS16.copyWith(bottom: 8.h),
                child: ValueListenableBuilder<String>(
                  valueListenable: _sortNotifier,
                  builder: (_, __, ___) => AppDropdownTextField(
                    controller: _sortController,
                    pickedValueNotifier: _sortNotifier,
                    hint: 'Sort by name',
                    items: AppConstants.sortOptions,
                    onChanged: (value) {
                      context.read<HomeBloc>().add(
                            SortUsersEvent(
                              isAscending: value == AppConstants.sortAZ,
                            ),
                          );
                    },
                  ),
                ),
              ),
            ),
          ),
          body: AutoRefreshBuilder(
            onRetry: () => context.read<HomeBloc>().add(FetchUsersEvent()),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is UserListLoadingState) {
                  return Skeletonizer(
                    enabled: true,
                    child: AppListView.builder(
                      padding: AppSpacing.symmetricHS16,
                      itemCount: 6,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          leading: const CircleAvatar(child: SizedBox.shrink()),
                          title: Text(
                            'User Full Name',
                            style: AppTextStyle.headingSmall.copyWith(
                              fontSize: 15.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (state is UserListLoadedState) {
                  final users = state.users;
                  return AppRefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(FetchUsersEvent());
                    },
                    child: AppListView.builder(
                      padding: AppSpacing.symmetricHS16,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1),
                              backgroundImage:
                                  user.avatar != null && user.avatar!.isNotEmpty
                                  ? NetworkImage(user.avatar!)
                                  : null,
                              child: user.avatar == null || user.avatar!.isEmpty
                                  ? Text(
                                      user.firstName?.isNotEmpty == true
                                          ? user.firstName![0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            title: Text(
                              user.fullName,
                              style: AppTextStyle.headingSmall.copyWith(
                                fontSize: 15.r,
                              ),
                            ),
                            subtitle: Text(
                              user.email ?? '',
                              style: AppTextStyle.bodySmall,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if (state is UserListFailedState) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.errorMessage),
                        AppSpacing.vs12,
                        ElevatedButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(FetchUsersEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    ),
  );
}
