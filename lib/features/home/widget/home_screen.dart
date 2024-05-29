import 'package:elbazar_app/screen/list/products_list_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductsListScreen(),
    );
  }
}