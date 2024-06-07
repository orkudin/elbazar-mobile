import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomerRegisterComplete extends ConsumerStatefulWidget {
  const CustomerRegisterComplete({super.key, required this.uuid});
  final String uuid;

  @override
  ConsumerState<CustomerRegisterComplete> createState() =>
      _CustomerRegisterCompleteState();
}

class _CustomerRegisterCompleteState
    extends ConsumerState<CustomerRegisterComplete> {
  final _formKey = GlobalKey<FormState>();

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _iinController = TextEditingController();
  final _genderController = TextEditingController();
  final _passwordController = TextEditingController();


  final List<String> gender = ['FEMALE', 'MALE'];
  String? selectedGender;

  @override
  void dispose() {
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _iinController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register to account',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                Text(
                  'Enter your details below',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                TextFormField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    label: Text(
                      'First name',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    label: Text(
                      'Last name',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    label: Text(
                      'Phone number',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                TextFormField(
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  controller: _iinController,
                  decoration: InputDecoration(
                    label: Text(
                      'IIN',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your IIN';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                DropdownButton<String>(
                  value: selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      selectedGender = newValue;
                      print(selectedGender);
                    });
                  },
                  items: gender.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    label: Text(
                      'Password',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
          
                // if (authState.isAuthenticated) Text("${authState.token}"),
          
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: const Color.fromRGBO(219, 68, 68, 1),
                          foregroundColor: const Color.fromRGBO(250, 250, 250, 1),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await authRepository
                                  .registerCustomerComplete(
                                      uuid: widget.uuid,
                                      password: _passwordController.text,
                                      firstname: _firstnameController.text,
                                      lastname: _lastnameController.text,
                                      phone: _phoneController.text,
                                      iin: _iinController.text,
                                      gender: selectedGender!)
                                  .whenComplete(() => context.go('/login'));
                            } catch (e) {
                              // Handle login error
                              print('Register failed: $e');
                              // ignore: use_build_context_synchronously
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //       content: Text('Incorrect login data')),
                              // );
                            }
                          }
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
