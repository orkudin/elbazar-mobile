import 'package:elbazar_app/data/network/entity/seller_entity.dart';
import 'package:elbazar_app/data/repository/auth_repository.dart';
import 'package:elbazar_app/domain/model/seller_state.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/seller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final List<String> roles = ['sales', 'customer', 'admin'];
  String? selectedRole;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedRole = roles[0];
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final authStateNotifier = ref.watch(authStateProvider.notifier);
    final sellerInfoStateNotifier = ref.watch(sellerStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(context, 'Log in to account'),
              _buildTitle(context, 'Enter your details below'),
              SizedBox(
                height: 16,
              ),
              _buildRoleDropdown(),
              _buildTextField(
                context,
                controller: _usernameController,
                label: 'Email',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your email'
                    : null,
              ),
              SizedBox(
                height: 16,
              ),
              _buildTextField(
                context,
                controller: _passwordController,
                label: 'Password',
                obscureText: _obscurePassword,
                suffixIcon: _buildPasswordVisibilityIcon(),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your password'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildLoginButton(authRepository, authStateNotifier,
                  sellerInfoStateNotifier, context),
              _buildRegisterRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButton<String>(
      value: selectedRole,
      onChanged: (newValue) {
        setState(() {
          selectedRole = newValue;
        });
      },
      items: roles.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(BuildContext context,
      {required TextEditingController controller,
      required String label,
      bool obscureText = false,
      Widget? suffixIcon,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordVisibilityIcon() {
    return IconButton(
      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
    );
  }

  Widget _buildLoginButton(
      AuthRepository authRepository,
      AuthStateNotifier authStateNotifier,
      SellerStateNotifier sellerInfoStateNotifier,
      BuildContext context) {
    return Row(
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
                  final token = await authRepository.loginUserData(
                    username: _usernameController.text,
                    password: _passwordController.text,
                    role: selectedRole!,
                  );
                  print('--------------3-------------');
                  print(token);
                  print('---------------3------------');
                  print('--------------3-------------');
                  print(token.role);
                  print('---------------3------------');
                  print('--------------3-------------');
                  print(token.jwt);
                  print('---------------3------------');
                  print('--------------3-------------');
                  print(token.userData);
                  print('---------------3------------');

                  var userState;
                  if (token.role == 'ADMIN') {
                    userState = 'Adminka';
                    authStateNotifier.authenticate(
                        token.jwt, token.role, userState);
                    // ignore: use_build_context_synchronously
                    context.go('/adminPanel');
                  } else if (token.role == 'SALES') {
                    userState = SellerEntity.fromJson(token.userData);
                    sellerInfoStateNotifier.setSeller(userState);
                    authStateNotifier.authenticate(
                        token.jwt, token.role, userState);
                    // ignore: use_build_context_synchronously
                    context.go('/home');
                  } else if (token.role == 'CUSTOMER') {
                    authStateNotifier.authenticate(token.jwt, token.role, null);
                    context.go('/home');
                  } else {
                    // ignore: use_build_context_synchronously
                    context.go('/home');
                  }
                  ;
                } catch (e) {
                  // Handle login error
                  print('Login failed: $e');
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect login data')),
                  );
                }
              }
            },
            child: const Text(
              'Log in',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Haven't account?"),
        TextButton(
          onPressed: () => selectedRole == 'sales'
              ? context.go('/registerSeller')
              : context.go('/registerCustomer'),
          child: const Text('Register'),
        ),
      ],
    );
  }
}
