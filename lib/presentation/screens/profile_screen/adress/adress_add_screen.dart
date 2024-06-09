import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/models/city_model.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/customer_repository_provider.dart';

final citiesProvider = FutureProvider<List<CityModel>>((ref) async {
  final customerRepository = ref.read(customerRepositoryProvider);
  return await customerRepository.getCitiesList();
});

class AddressAddScreen extends ConsumerStatefulWidget {
  const AddressAddScreen({Key? key}) : super(key: key);

  @override
  _AddressAddScreenState createState() => _AddressAddScreenState();
}

class _AddressAddScreenState extends ConsumerState<AddressAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _houseController = TextEditingController();
  final _apartmentsController = TextEditingController();
  CityModel? _selectedCity;

  Future<void> _addAddress(BuildContext context) async {
    final authState = ref.read(authStateProvider);
    final customerRepository = ref.read(customerRepositoryProvider);

    if (_formKey.currentState!.validate() && _selectedCity != null) {
      try {
        await customerRepository.addAddress(
          jwt: authState.token,
          cityId: _selectedCity!.id,
          street: _streetController.text,
          house: _houseController.text,
          apartments: _apartmentsController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address added successfully!')),
        );
        Navigator.of(context).pop(); // Return to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding address: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly.')),
      );
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _houseController.dispose();
    _apartmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final citiesAsyncValue = ref.watch(citiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              citiesAsyncValue.when(
                data: (cities) => DropdownButtonFormField<CityModel>(
                  value: _selectedCity,
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (newCity) {
                    setState(() {
                      _selectedCity = newCity;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) =>
                  value == null ? 'Please select a city' : null,
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Text('Error: $error'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Street'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a street' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _houseController,
                decoration: const InputDecoration(labelText: 'House'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a house' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _apartmentsController,
                decoration: const InputDecoration(labelText: 'Apartments'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter apartments'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _addAddress(context),
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}