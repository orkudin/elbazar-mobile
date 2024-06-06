import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SellerRegisterConfirm extends ConsumerStatefulWidget {
  const SellerRegisterConfirm({super.key, required this.uuid});
  final String uuid;

  @override
  ConsumerState<SellerRegisterConfirm> createState() =>
      _SellerRegisterConfirmState();
}

class _SellerRegisterConfirmState extends ConsumerState<SellerRegisterConfirm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
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
              SizedBox(height: 16,),
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
                                .registerSellerConfirm(
                                    uuid: widget.uuid,
                                    code: _codeController.text,
                                    password: _passwordController.text)
                                .whenComplete(() => context.go('/login'));
                          } catch (e) {
                            // Handle login error
                            print('Register failed: $e');
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Incorrect login data')),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Register account',
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
