import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/screens/seller_register/seller_register_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerRegister extends ConsumerStatefulWidget {
  const SellerRegister({super.key});

  @override
  ConsumerState<SellerRegister> createState() => _SellerRegisterState();
}

class _SellerRegisterState extends ConsumerState<SellerRegister> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailNameController = TextEditingController();
  final _companyTypeController = TextEditingController();
  final _binController = TextEditingController();

  final List<String> roles = ['IP', 'TOO', 'AO'];
  String? selectedCompanyType;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailNameController.dispose();
    _companyTypeController.dispose();
    _binController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedCompanyType = roles[0];
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
              SizedBox(height: 16,),
              TextFormField(
                controller: _firstNameController,
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
                controller: _lastNameController,
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
                controller: _emailNameController,
                decoration: InputDecoration(
                  label: Text(
                    'Email',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16,),
              DropdownButton<String>(
                value: selectedCompanyType,
                onChanged: (newValue) {
                  setState(() {
                    selectedCompanyType = newValue;
                    print(selectedCompanyType);
                  });
                },
                items: roles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16,),
              TextFormField(
                controller: _binController,
                decoration: InputDecoration(
                  label: Text(
                    'BIN',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your BIN';
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
                                .registerSeller(
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailNameController.text,
                                    companyType: selectedCompanyType!,
                                    bin: _binController.text)
                                .then(
                                  (uuid) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SellerRegisterConfirm(uuid: uuid),
                                    ),
                                  ),
                                );
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
    );
  }
}
