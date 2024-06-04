import 'package:elbazar_app/config/routes/root_screen.dart';
import 'package:elbazar_app/presentation/screens/cart_screen.dart';
import 'package:elbazar_app/presentation/screens/categories_screen.dart';
import 'package:elbazar_app/presentation/screens/customer_register/customer_register.dart';
import 'package:elbazar_app/presentation/screens/home_screen/home_screen.dart';
import 'package:elbazar_app/presentation/screens/login_user/login_screen.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/profile_screen.dart';
import 'package:elbazar_app/presentation/screens/seller_register/seller_register.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/registerSeller',
      builder: (context, state) => const SellerRegister(),
    ),
    GoRoute(
      path: '/registerCustomer',
      builder: (context, state) => const CustomerRegister(),
    ),
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
              builder: (context, state) => ProfileScreen(),
            )
          ],
        ),
      ],
    ),
  ],
);
