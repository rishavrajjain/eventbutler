import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/reminders_provider.dart';
import 'providers/shopping_lists_provider.dart';
import 'providers/tasks_provider.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/loading_widget.dart';

class EventButlerApp extends StatelessWidget {
  const EventButlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ShoppingListsProvider>(
          create: (_) => ShoppingListsProvider(),
          update: (_, auth, lists) {
            final provider = lists ?? ShoppingListsProvider();
            if (auth.isAuthenticated && auth.userId != null) {
              provider.setUser(auth.userId!);
            }
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, RemindersProvider>(
          create: (_) => RemindersProvider(),
          update: (_, auth, reminders) {
            final provider = reminders ?? RemindersProvider();
            if (auth.isAuthenticated && auth.userId != null) {
              provider.setUser(auth.userId!);
            }
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, TasksProvider>(
          create: (_) => TasksProvider(),
          update: (_, auth, tasks) {
            final provider = tasks ?? TasksProvider();
            if (auth.isAuthenticated && auth.userId != null) {
              provider.setUser(auth.userId!);
            }
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Event Butler',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const LoadingWidget(message: 'Signing in...');
        }
        if (auth.isAuthenticated) return const HomeScreen();
        return const AuthScreen();
      },
    );
  }
}
