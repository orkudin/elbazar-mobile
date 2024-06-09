import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/screens/register_customer_screen/customer_register_complete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerRegisterConfirm extends ConsumerStatefulWidget {
  const CustomerRegisterConfirm({super.key, required this.uuid, required this.email});
  final String uuid;
  final String email;

  @override
  ConsumerState<CustomerRegisterConfirm> createState() =>
      _CustomerRegisterConfirmState();
}

class _CustomerRegisterConfirmState
    extends ConsumerState<CustomerRegisterConfirm> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();

  final List<String> roles = ['IP', 'TOO', 'AO'];
  String? selectedCompanyType;

  @override
  void dispose() {
    _codeController.dispose();
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
                'Code sent to ${widget.email}. Enter your details below',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  label: Text(
                    'Code',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your code';
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
                            final response =
                                await authRepository.registerCustomerConfirm(
                                    uuid: widget.uuid,
                                    code: _codeController.text);
                            print('--------------2-------------');
                            print(response);
                            print('---------------2------------');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CustomerRegisterComplete(
                                    uuid: widget.uuid)));
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
