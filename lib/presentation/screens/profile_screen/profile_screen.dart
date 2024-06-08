// import 'package:elbazar_app/presentation/provider/auth_provider.dart';
// import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
// import 'package:elbazar_app/presentation/provider/seller_provider.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/add_product_screen.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/become_a_seller_screen.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/my_products_screen/seller_products.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/order_screen.dart';
// import 'package:elbazar_app/presentation/screens/profile_screen/prodile_edit_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// final sellerInformationProvider = FutureProvider<SellerEntity>((ref) async {
//   final sellerRepository = ref.read(sellerRepositoryProvider);
//   final authState = ref.watch(authStateProvider);
//   return sellerRepository.getSellerInformation(jwt: authState.token);
// });
//
// class ProfileScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authStateProvider);
//
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
//                 data: (sellerInfo) => Card(
//                   margin: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         title: const Text('Edit Profile'),
//                         trailing: const Icon(Icons.edit),
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => const ProfileEditScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Username: ${sellerInfo.firstName}'),
//                             const SizedBox(height: 8.0),
//                             Text('Email: ${sellerInfo.email}'),
//                             const SizedBox(height: 8.0),
//                             Text('Phone: ${sellerInfo.phone}'),
//                             const SizedBox(height: 8.0),
//                             Text('BIN: ${sellerInfo.bin}'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 error: (error, stackTrace) =>
//                     Center(child: Text('Error: $error')),
//                 loading: () => const Center(child: CircularProgressIndicator()),
//               ),
//             if (authState.token.isEmpty)
//               Card(
//                 margin: const EdgeInsets.symmetric(
//                     horizontal: 16.0, vertical: 8.0),
//                 child: ListTile(
//                   title: const Text('Log into an account'),
//                   trailing: const Icon(Icons.arrow_forward),
//                   onTap: () {
//                     context.go('/login');
//                   },
//                 ),
//               ),
//             if (authState.role != 'CUSTOMER' && authState.userInfo!.approved == true)
//               Card(
//                 margin: const EdgeInsets.symmetric(
//                     horizontal: 16.0, vertical: 8.0),
//                 child: ListTile(
//                   title: const Text('Add Product'),
//                   trailing: const Icon(Icons.arrow_forward),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => UploadProductScreen()),
//                     );
//                   },
//                 ),
//               ),
//             if (authState.role != 'CUSTOMER' && authState.userInfo!.approved == true)
//               Card(
//                 margin: const EdgeInsets.symmetric(
//                     horizontal: 16.0, vertical: 8.0),
//                 child: ListTile(
//                   title: const Text('My Products'),
//                   trailing: const Icon(Icons.arrow_forward),
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
//               margin: const EdgeInsets.symmetric(
//                   horizontal: 16.0, vertical: 8.0),
//               child: ListTile(
//                 title: const Text('Orders'),
//                 trailing: const Icon(Icons.arrow_forward),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SellerOrdersScreen()),
//                   );
//                 },
//               ),
//             ),
//             if (authState.role != 'CUSTOMER' && authState.userInfo!.approved != true)
//               Card(
//                 margin: const EdgeInsets.symmetric(
//                     horizontal: 16.0, vertical: 8.0),
//                 child: ListTile(
//                   title: const Text('Become a Seller'),
//                   trailing: const Icon(Icons.arrow_forward),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const BecomeASellerScreen()),
//                     );
//                   },
//                 ),
//               ),
//             Card(
//               margin: const EdgeInsets.symmetric(
//                   horizontal: 16.0, vertical: 8.0),
//               child: ListTile(
//                 title: const Text('Log out'),
//                 trailing: const Icon(Icons.arrow_forward),
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
//   }
// }


import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/add_product_screen.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/order/order_screen.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/prodile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/users_model/admin_model.dart';
import '../../../data/models/users_model/customer_model.dart';
import '../../../data/models/users_model/seller_model.dart';
import '../../../data/models/users_model/user_model.dart';
import 'become_a_seller_screen.dart';
import 'my_products_screen/seller_products.dart';

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
            if (authState.isAuthenticated)
              _buildProfileSection(authState.userInfo, authState.role, context),
            if (!authState.isAuthenticated)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: const Text('Log into an account'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    context.go('/login');
                  },
                ),
              ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(UserModel? userInfo, String role, BuildContext context) {
    if (userInfo is SellerModel) {
      return Column(
        children: [
          _buildSellerProfileSection(userInfo, context),
          if (userInfo.approved)
            _buildSellerActions(context),
          if (!userInfo.approved)
            _buildBecomeASellerCard(context),
        ],
      );
    } else if (userInfo is CustomerModel) {
      return _buildCustomerProfileSection(userInfo, context);
    } else if (userInfo is AdminModel) {
      return _buildAdminProfileSection(userInfo, context);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildSellerProfileSection(SellerModel seller, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
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
                Text('Username: ${seller.firstName} ${seller.lastName}'),
                const SizedBox(height: 8.0),
                Text('Email: ${seller.email}'),
                const SizedBox(height: 8.0),
                Text('Phone: ${seller.phone}'),
                const SizedBox(height: 8.0),
                Text('BIN: ${seller.bin}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerActions(BuildContext context) {
    return Column(
        children: [
    Card(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: ListTile(
    title: const Text('Add Product'),
    trailing: const Icon(Icons.arrow_forward),
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UploadProductScreen()),
    );
    },
    ), ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
        ],
    );
  }

  Widget _buildBecomeASellerCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: const Text('Become a Seller'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BecomeASellerScreen()),
          );
        },
      ),
    );
  }

  Widget _buildCustomerProfileSection(CustomerModel customer, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
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
                Text('Username: ${customer.firstName} ${customer.lastName}'),
                const SizedBox(height: 8.0),
                Text('Email: ${customer.email}'),
                const SizedBox(height: 8.0),
                Text('Phone: ${customer.phone}'),
                const SizedBox(height: 8.0),
                Text('IIN: ${customer.iin}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminProfileSection(AdminModel admin, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Admin Profile'),
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
                Text('Role: ${admin.role}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}