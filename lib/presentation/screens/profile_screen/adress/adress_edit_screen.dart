// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:elbazar_app/data/models/address_model.dart';
//
// import '../../../provider/auth_provider.dart';
// import '../../../provider/customer_repository_provider.dart';
//
// class AddressEditScreen extends ConsumerStatefulWidget {
//   final AddressModel address;
//
//   const AddressEditScreen({Key? key, required this.address}) : super(key: key);
//
//   @override
//   _AddressEditScreenState createState() => _AddressEditScreenState();
// }
//
// class _AddressEditScreenState extends ConsumerState<AddressEditScreen> {
//   late TextEditingController _streetController;
//   late TextEditingController _houseController;
//   late TextEditingController _apartmentsController;
//
//   @override
//   void initState() {
//     super.initState();
//     _streetController = TextEditingController(text: widget.address.street);
//     _houseController = TextEditingController(text: widget.address.house);
//     _apartmentsController =
//         TextEditingController(text: widget.address.apartments);
//   }
//
//   @override
//   void dispose() {
//     _streetController.dispose();
//     _houseController.dispose();
//     _apartmentsController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateAddress() async {
//     final authState = ref.read(authStateProvider);
//     final customerRepository = ref.read(customerRepositoryProvider);
//
//     try {
//       await customerRepository.updateAddress(
//         jwt: authState.token,
//         cityId: widget.address.city.id,
//         street: _streetController.text,
//         house: _houseController.text,
//         apartments: _apartmentsController.text,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Address updated successfully!')),
//       );
//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating address: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Address'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _streetController,
//               decoration: const InputDecoration(labelText: 'Street'),
//             ),
//             SizedBox(height: 16,),
//             TextField(
//               controller: _houseController,
//               decoration: const InputDecoration(labelText: 'House'),
//             ),            SizedBox(height: 16,),
//
//             TextField(
//               controller: _apartmentsController,
//               decoration: const InputDecoration(labelText: 'Apartments'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _updateAddress,
//               child: const Text('Update Address'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/models/address_model.dart';
import 'package:elbazar_app/data/models/city_model.dart';

import '../../../provider/auth_provider.dart';
import '../../../provider/customer_repository_provider.dart';


final citiesProvider = FutureProvider<List<CityModel>>((ref) async {
  final customerRepository = ref.read(customerRepositoryProvider);
  return await customerRepository.getCitiesList();
});

class AddressEditScreen extends ConsumerStatefulWidget {
  final AddressModel address;

  const AddressEditScreen({Key? key, required this.address}) : super(key: key);

  @override
  _AddressEditScreenState createState() => _AddressEditScreenState();
}

class _AddressEditScreenState extends ConsumerState<AddressEditScreen> {
  late TextEditingController _streetController;
  late TextEditingController _houseController;
  late TextEditingController _apartmentsController;
  late int _selectedCityId;

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController(text: widget.address.street);
    _houseController = TextEditingController(text: widget.address.house);
    _apartmentsController =
        TextEditingController(text: widget.address.apartments);
    _selectedCityId = widget.address.city.id;
  }

  @override
  void dispose() {
    _streetController.dispose();
    _houseController.dispose();
    _apartmentsController.dispose();
    super.dispose();
  }

  Future<void> _updateAddress() async {
    final authState = ref.read(authStateProvider);
    final customerRepository = ref.read(customerRepositoryProvider);

    try {
      await customerRepository.updateAddress(
        jwt: authState.token,
        cityId: _selectedCityId,
        street: _streetController.text,
        house: _houseController.text,
        apartments: _apartmentsController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address updated successfully!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating address: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final citiesAsyncValue = ref.watch(citiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            citiesAsyncValue.when(
              data: (cities) {
                return DropdownButtonFormField<int>(
                  value: _selectedCityId,
                  items: cities.map((CityModel city) {
                    return DropdownMenuItem<int>(
                      value: city.id,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (int? newCityId) {
                    setState(() {
                      _selectedCityId = newCityId!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) =>
                  Text('Error loading cities: $error'),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: 'Street'),
            ),            SizedBox(height: 16,),

            TextField(
              controller: _houseController,
              decoration: const InputDecoration(labelText: 'House'),
            ),            SizedBox(height: 16,),

            TextField(
              controller: _apartmentsController,
              decoration: const InputDecoration(labelText: 'Apartments'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateAddress,
              child: const Text('Update Address'),
            ),
          ],
        ),
      ),
    );
  }
}

