// import 'package:elbazar_app/data/network/entity/seller_entity.dart';
// import 'package:elbazar_app/presentation/provider/auth_provider.dart';
// import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
// import 'package:elbazar_app/presentation/provider/seller_provider.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/add_product_screen.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/become_a_seller_screen.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/my_products_screen/seller_products.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/prodile_edit_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// final sellerInformationProvider = FutureProvider<SellerEntity>((ref) async {
//   final sellerRepository = ref.read(sellerRepositoryProvider);
//   final authState = ref.watch(authStateProvider);
//   return sellerRepository.getSellerInformation(jwt: authState.token);
// });

// class ProfileScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final authStateNotifier = ref.watch(authStateProvider.notifier);
//     // final authState = ref.watch(authStateProvider);
//     final authState = ref.watch(authStateProvider);
//     print('------------------------------------');
//     print(authState.userInfo!.approved);
//     print('------------------------------------');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (authState.token.isNotEmpty &&
//                 authState.role != 'ADMIN' &&
//                 authState.role != 'CUSTOMER')
//               ref.watch(sellerInformationProvider).when(
//                     data: (sellerInfo) => Card(
//                       margin: EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ListTile(
//                             title: Text('Edit Profile'),
//                             trailing: Icon(Icons.edit),
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => ProfileEditScreen(),
//                                 ),
//                               );
//                               // Обработчик нажатия на "Edit Profile"
//                             },
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Username: ${sellerInfo.firstName}'),
//                                 SizedBox(height: 8.0),
//                                 Text('Email: ${sellerInfo.email}'),
//                                 SizedBox(height: 8.0),
//                                 Text('Phone: ${sellerInfo.phone}'),
//                                 SizedBox(height: 8.0),
//                                 Text('BIN: ${sellerInfo.bin}'),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     error: (error, stackTrace) =>
//                         Center(child: Text('Error: $error')),
//                     loading: () => Center(child: CircularProgressIndicator()),
//                   ),
//             if (authState.token.isEmpty)
//               Card(
//                 margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: ListTile(
//                   title: Text('Log into an account'),
//                   trailing: Icon(Icons.arrow_forward),
//                   onTap: () {
//                     context.go('/login');
//                   },
//                 ),
//               ),
//             if (authState.userInfo!.approved == true)
//               Card(
//                 margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: ListTile(
//                   title: Text('Add Product'),
//                   trailing: Icon(Icons.arrow_forward),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => UploadProductScreen()),
//                     );
//                   },
//                 ),
//               ),
//             if (authState.userInfo!.approved == true)
//               Card(
//                 margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: ListTile(
//                   title: Text('My Products'),
//                   trailing: Icon(Icons.arrow_forward),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SellerProducts()),
//                     );
//                   },
//                 ),
//               ),
//             // Card(
//             //   margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             //   child: ListTile(
//             //     title: Text('Choose Language'),
//             //     trailing: Icon(Icons.arrow_forward),
//             //     onTap: () {
//             //       // Обработчик нажатия на "Choose Language"
//             //     },
//             //   ),
//             // ),
//             Card(
//               margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: ListTile(
//                 title: Text('Orders'),
//                 trailing: Icon(Icons.arrow_forward),
//                 onTap: () {
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) => OrdersScreen()),
//                   // );
//                 },
//               ),
//             ),
//             if (authState.userInfo!.approved != true)
//               Card(
//                 margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: ListTile(
//                   title: Text('Become a Seller'),
//                   trailing: Icon(Icons.arrow_forward),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => BecomeASellerScreen()),
//                     );
//                   },
//                 ),
//               ),
//             Card(
//               margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: ListTile(
//                 title: Text('Log out'),
//                 trailing: Icon(Icons.arrow_forward),
//                 onTap: () {
//                   context.go('/login');
//                   // ref.watch(sellerStateProvider.notifier).clearSeller();
//                   // ref.watch(authStateProvider.notifier).logout();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

//     //   Column(
//     //     children: [
//     //       Center(child: Text('ProfileScreen')),
//     //       if (authState.isAuthenticated) Text("${authState.token}"),
//     //       ElevatedButton(
//     //           onPressed: () {
//     //             authStateNotifier.logout();
//     //           },
//     //           child: Text('Log out'))
//     //     ],
//     //   ),
//     // );
//   }
// }


import 'package:elbazar_app/data/network/entity/seller_entity.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/provider/seller_provider.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/add_product_screen.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/become_a_seller_screen.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/my_products_screen/seller_products.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/order_screen.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/prodile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final sellerInformationProvider = FutureProvider<SellerEntity>((ref) async {
  final sellerRepository = ref.read(sellerRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  return sellerRepository.getSellerInformation(jwt: authState.token);
});

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (authState.token.isNotEmpty &&
                authState.role != 'ADMIN' &&
                authState.role != 'CUSTOMER')
              ref.watch(sellerInformationProvider).when(
                data: (sellerInfo) => Card(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: const Text('Edit Profile'),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileEditScreen(),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username: ${sellerInfo.firstName}'),
                            const SizedBox(height: 8.0),
                            Text('Email: ${sellerInfo.email}'),
                            const SizedBox(height: 8.0),
                            Text('Phone: ${sellerInfo.phone}'),
                            const SizedBox(height: 8.0),
                            Text('BIN: ${sellerInfo.bin}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            if (authState.token.isEmpty)
              Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: const Text('Log into an account'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    context.go('/login');
                  },
                ),
              ),
            if (authState.userInfo!.approved == true)
              Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: const Text('Add Product'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadProductScreen()),
                    );
                  },
                ),
              ),
            if (authState.userInfo!.approved == true)
              Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: const Text('My Products'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SellerProducts()),
                    );
                  },
                ),
              ),
            // Card(
            //   margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //   child: ListTile(
            //     title: Text('Choose Language'),
            //     trailing: Icon(Icons.arrow_forward),
            //     onTap: () {
            //       // Обработчик нажатия на "Choose Language"
            //     },
            //   ),
            // ),
            Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                title: const Text('Orders'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SellerOrdersScreen()),
                  );
                },
              ),
            ),
            if (authState.userInfo!.approved != true)
              Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: const Text('Become a Seller'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BecomeASellerScreen()),
                    );
                  },
                ),
              ),
            Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                title: const Text('Log out'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  context.go('/login');
                  // ref.watch(sellerStateProvider.notifier).clearSeller();
                  // ref.watch(authStateProvider.notifier).logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}