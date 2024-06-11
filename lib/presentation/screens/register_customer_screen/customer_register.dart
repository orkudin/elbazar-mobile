import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/screens/register_customer_screen/customer_register_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/network_error_model/network_excepton.dart';
import '../../../domain/exception/network_exception.dart';

class CustomerRegister extends ConsumerStatefulWidget {
  const CustomerRegister({super.key});

  @override
  ConsumerState<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends ConsumerState<CustomerRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailNameController = TextEditingController();

  @override
  void dispose() {
    _emailNameController.dispose();
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
              SizedBox(
                height: 16,
              ),
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
                      // onPressed: () async {
                      //   if (_formKey.currentState!.validate()) {
                      //     try {
                      //       final response = await authRepository
                      //           .registerCustomer(
                      //         email: _emailNameController.text,
                      //       )
                      //           .catchError((error, stackTrace) {
                      //         return ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(content: Text('${error}')),
                      //         );
                      //       }).then(
                      //         (uuid) => Navigator.of(context).push(
                      //           MaterialPageRoute(
                      //             builder: (context) =>
                      //                 CustomerRegisterConfirm(uuid: uuid),
                      //           ),
                      //         ),
                      //       );
                      //     } catch (e) {
                      //       // Handle login error
                      //       print('Register failed: $e');
                      //     }
                      //   }
                      // },

                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final response =
                                await authRepository.registerCustomer(
                              email: _emailNameController.text,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomerRegisterConfirm(uuid: response, email: _emailNameController.text),
                              ),
                            );
                          } catch (e) {
                            if (e is NetworkException) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message!)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('An unexpected error occurred')),
                              );
                            }
                            print('Register failed: $e');
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
