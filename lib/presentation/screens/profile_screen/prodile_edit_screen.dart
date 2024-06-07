// import 'package:elbazar_app/data/network/entity/seller_entity.dart';
// import 'package:elbazar_app/presentation/provider/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class ProfileEditScreen extends ConsumerStatefulWidget {
//   const ProfileEditScreen({super.key, required this.sellerEntity});

//   final SellerEntity sellerEntity;

//   @override
//   ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
// }

// class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _iinController = TextEditingController();
//   final List<String> gender = ['MALE', 'FEMALE'];
//   String? selectedGender;

//   @override
//   void initState() {
//     final authState = ref.watch(authStateProvider);

//     super.initState();
//     selectedGender = gender[0];
//     _firstNameController.text = authState.userInfo.firstName;
//     _lastNameController.text = authState.userInfo.lastName;
//     _phoneController.text = authState.userInfo.phone;
//     _iinController.text = authState.userInfo.firstName;
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _phoneController.dispose();
//     _iinController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authRepository = ref.watch(authRepositoryProvider);
//     final authStateNotifier = ref.watch(authStateProvider.notifier);
//     final authState = ref.watch(authStateProvider);
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Profile')),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Text(
//                 'Log in to account',
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                     color: Theme.of(context).colorScheme.onBackground),
//               ),
//               Text(
//                 'Enter your details below',
//                 style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                     color: Theme.of(context).colorScheme.onBackground),
//               ),
//               DropdownButton<String>(
//                 value: selectedGender,
//                 onChanged: (newValue) {
//                   setState(() {
//                     selectedGender = newValue;
//                     print(selectedGender);
//                   });
//                 },
//                 items: gender.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: InputDecoration(
//                   label: Text(
//                     'First name',
//                     style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                         color: Theme.of(context).colorScheme.onBackground),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your first name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: InputDecoration(
//                   label: Text(
//                     'Last name',
//                     style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                         color: Theme.of(context).colorScheme.onBackground),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your last name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(
//                   label: Text(
//                     'Phone number',
//                     style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                         color: Theme.of(context).colorScheme.onBackground),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _iinController,
//                 decoration: InputDecoration(
//                   label: Text(
//                     'IIN',
//                     style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                         color: Theme.of(context).colorScheme.onBackground),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your IIN';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5.0),
//                         ),
//                         backgroundColor: const Color.fromRGBO(219, 68, 68, 1),
//                         foregroundColor: const Color.fromRGBO(250, 250, 250, 1),
//                       ),
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           // try {
//                           //   final token = await authRepository.loginUserData(
//                           //       username: _usernameController.text,
//                           //       password: _passwordController.text,
//                           //       role: selectedRole!);
//                           //   authStateNotifier.authenticate(
//                           //       token.jwt, token.role);
//                           //   // ignore: use_build_context_synchronously
//                           //   context.go('/home');
//                           // } catch (e) {
//                           //   // Handle login error
//                           //   print('Login failed: $e');
//                           //   // ignore: use_build_context_synchronously
//                           //   ScaffoldMessenger.of(context).showSnackBar(
//                           //     const SnackBar(
//                           //         content: Text('Incorrect login data')),
//                           //   );
//                           // }
//                         }
//                       },
//                       child: const Text(
//                         'Log in',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:elbazar_app/data/network/entity/seller_entity.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _iinController = TextEditingController();
  final _binController = TextEditingController();
  final List<String> gender = ['MALE', 'FEMALE'];
  String? selectedGender;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); // Call super first

    final authState = ref.watch(authStateProvider);
    // Initialize controllers with values from authState.userInfo
    _firstNameController.text = authState.userInfo!.firstName;
    _lastNameController.text = authState.userInfo!.lastName;
    _phoneController.text = authState.userInfo!.phone ?? '';
    _iinController.text = authState.userInfo!.iin ?? '';
    _binController.text = authState.userInfo!.bin;
    selectedGender = authState.userInfo!.gender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _iinController.dispose();
    _binController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final sellerRepository = ref.watch(sellerRepositoryProvider);
    final authStateNotifier = ref.watch(authStateProvider.notifier);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                  items: gender.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _iinController,
                  decoration: const InputDecoration(
                    labelText: 'IIN',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your IIN';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _binController, // Add the bin field
                  decoration: const InputDecoration(
                    labelText: 'BIN',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your BIN';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final updatedSeller = SellerEntity(
                            id: authState.userInfo!
                                .id, // Assuming you have an 'id' in your SellerEntity
                            deleted: authState.userInfo!.deleted,
                            created: authState.userInfo!.created,
                            bin: _binController
                                .text, // Get bin from the controller
                            email: authState.userInfo!.email,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            phone: _phoneController.text,
                            iin: _iinController.text,
                            gender: selectedGender,
                            companyType: authState.userInfo!.companyType,
                            approved: authState.userInfo!.approved,
                          );

                          // Update the user profile in the repository
                          await sellerRepository.updateSellerInformation(
                            jwt: authState.token, // Pass the JWT from authState
                            bin: _binController
                                .text, // Pass bin to the repository
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            phone: _phoneController.text,
                            iin: _iinController.text,
                            gender: selectedGender!,
                          );

                          // Update the auth state
                          authStateNotifier.updateUserInfo(updatedSeller);

                          // Show success snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated')),
                          );

                          // Navigate back to the previous screen
                          context.pop();
                        } catch (e) {
                          // Handle update error
                          print('Update failed: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Update failed')),
                          );
                        }
                      }
                    },
                    child: const Text('Update Profile'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
