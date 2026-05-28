import 'package:auto_route/annotations.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/home/bloc/home_bloc.dart';
import 'package:bloc_architecture/values/app_spacing.dart';
import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:bloc_architecture/widgets/app_list_view.dart';
import 'package:bloc_architecture/widgets/auto_refresh_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<HomeBloc>(
    create: (_) => locator<HomeBloc>()..add(FetchUsersEvent()),
    child: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Users')),
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
                        subtitle: Text(
                          'user.email@example.com',
                          style: AppTextStyle.bodySmall,
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (state is UserListLoadedState) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(FetchUsersEvent());
                  },
                  child: AppListView.builder(
                    padding: AppSpacing.symmetricHS16,
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
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
  );
}
