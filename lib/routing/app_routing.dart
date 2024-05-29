import 'package:elbazar_app/features/cart/widget/cart_screen.dart';
import 'package:elbazar_app/features/categories/widget/categories_screen.dart';
import 'package:elbazar_app/features/home/widget/home_screen.dart';
import 'package:elbazar_app/features/profile/widget/profile_screen.dart';
import 'package:elbazar_app/routing/root_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) => const CategoriesScreen(),
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            )
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            )
          ],
        ),
      ],
    ),
  ],
);
