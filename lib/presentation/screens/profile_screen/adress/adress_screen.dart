import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/models/address_model.dart';

import '../../../../domain/exception/network_exception.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/customer_repository_provider.dart';
import 'adress_add_screen.dart';
import 'adress_edit_screen.dart';

final addressProvider = FutureProvider<AddressModel?>((ref) async {
  final customerRepository = ref.read(customerRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  return await customerRepository.getAddresses(jwt: authState.token);
});

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  Future<void> _refreshAddresses() async {
    await ref.refresh(addressProvider.future);
  }

  void _addAddress(BuildContext context) {
    // Navigate to Add Address screen or display Add Address dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Add Address screen')),
    );
  }

  Future<void> _deleteAddress(BuildContext context, int addressId) async {
    final authState = ref.read(authStateProvider);
    final customerRepository = ref.read(customerRepositoryProvider);

    try {
      await customerRepository.deleteAddress(
          jwt: authState.token, addressId: addressId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address deleted successfully!')),
      );
      ref.refresh(addressProvider); // Refresh addresses list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting address: $e')),
      );
    }
  }

  void _editAddress(BuildContext context, AddressModel address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressEditScreen(address: address),
      ),
    ).then((result) {
      if (result == true) {
        _refreshAddresses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressAsyncValue = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAddresses,
        child: addressAsyncValue.when(
          data: (address) {
            if (address == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No address found',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _addAddress(context),
                      child: const Text('Add Address'),
                    ),
                  ],
                ),
              );
            } else {
              return ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(address.fullAddress),
                      subtitle: Text(
                        '${address.street}, ${address.house}, ${address.apartments}, ${address.city.name}',
                      ),
                      onTap: () {
                        // Handle address tap
                        _editAddress(context, address);
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outlined),
                        onPressed: () => _deleteAddress(context, address.id),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            if (error is NetworkException) {
              return RefreshIndicator(
                onRefresh: _refreshAddresses,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'There is no address',
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressAddScreen(),
                            )),
                        child: const Text('Add Address'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'An unexpected error occurred',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshAddresses,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
