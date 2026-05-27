import 'package:auto_route/annotations.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/home/bloc/home_bloc.dart';
import 'package:bloc_architecture/values/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<HomeBloc>(
    create: (_) => locator<HomeBloc>()..add(FetchCategoriesEvent()),
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is CategoryListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryListLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(FetchCategoriesEvent());
              },
              child: ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return ListTile(title: Text(category.name));
                },
              ),
            );
          }
          if (state is CategoryListFailedState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage),
                  AppSpacing.vs12,
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(FetchCategoriesEvent());
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
  );
}
