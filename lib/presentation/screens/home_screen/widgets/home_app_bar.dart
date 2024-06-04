import 'package:elbazar_app/config/constatnts/colors.dart';
import 'package:elbazar_app/presentation/screens/cart_screen.dart';
import 'package:elbazar_app/presentation/screens/home_screen/widgets/custom_cart_counter_icon.dart';
import 'package:elbazar_app/presentation/screens/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: Text(
        'Home',
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .apply(color: CustomColors.black),
      ),
      actions: [
        CustomCartCounterIcon(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartScreen(),
              )),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
