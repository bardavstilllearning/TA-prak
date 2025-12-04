import 'package:bencanaku/Landing/emergency.dart';
import 'package:bencanaku/Landing/home.dart';
import 'package:bencanaku/Landing/notificationTest.dart';
import 'package:bencanaku/Landing/profile.dart';
import 'package:bencanaku/Landing/currency.dart';
import 'package:bencanaku/layout/layout.dart';
import 'package:go_router/go_router.dart';
import '../Auntentikasi/auth_page.dart';
import '../screens/splash.dart';
import '../services/sessionService.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    final location = state.uri.toString();

    if (location == '/splash' ||
        location == '/login' ||
        location == '/register' ||
        location == '/') {
      return null;
    }

    final isAuthenticated = await SessionService.checkAuthStatus();

    if (!isAuthenticated) {
      print('Redirecting to login - not authenticated');
      return '/login';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/', builder: (context, state) => const AuthPage()),
    GoRoute(path: '/login', builder: (context, state) => const AuthPage()),

    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(currentPath: state.uri.toString(), child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const Homepage()),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: '/emergency',
          builder: (context, state) => const EmergencyPage(),
        ),
        GoRoute(
          path: '/currency',
          builder: (context, state) => const CurrencyPage(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationTestPage(),
        ),
      ],
    ),
  ],
);
