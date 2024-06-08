// import 'package:elbazar_app/data/datasources/entity/seller_entity.dart';
// import 'package:elbazar_app/presentation/provider/auth_provider.dart';
// import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// class ProfileEditScreen extends ConsumerStatefulWidget {
//   const ProfileEditScreen({super.key});
//
//   @override
//   ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
// }
//
// class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _iinController = TextEditingController();
//   final _binController = TextEditingController();
//   final List<String> gender = ['MALE', 'FEMALE'];
//   String? selectedGender;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies(); // Call super first
//
//     final authState = ref.watch(authStateProvider);
//     // Initialize controllers with values from authState.userInfo
//     _firstNameController.text = authState.userInfo!.firstName;
//     _lastNameController.text = authState.userInfo!.lastName;
//     _phoneController.text = authState.userInfo!.phone ?? '';
//     _iinController.text = authState.userInfo!.iin ?? '';
//     _binController.text = authState.userInfo!.bin;
//     selectedGender = authState.userInfo!.gender;
//   }
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _phoneController.dispose();
//     _iinController.dispose();
//     _binController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authRepository = ref.watch(authRepositoryProvider);
//     final sellerRepository = ref.watch(sellerRepositoryProvider);
//     final authStateNotifier = ref.watch(authStateProvider.notifier);
//     final authState = ref.watch(authStateProvider);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Edit Profile')),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Edit Profile',
//                   style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: selectedGender,
//                   decoration: const InputDecoration(
//                     labelText: 'Gender',
//                   ),
//                   onChanged: (newValue) {
//                     setState(() {
//                       selectedGender = newValue;
//                     });
//                   },
//                   items: gender.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select your gender';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 TextFormField(
//                   controller: _firstNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'First Name',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your first name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 TextFormField(
//                   controller: _lastNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Last Name',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your last name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number',
//                   ),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 TextFormField(
//                   controller: _iinController,
//                   decoration: const InputDecoration(
//                     labelText: 'IIN',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your IIN';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 TextFormField(
//                   controller: _binController, // Add the bin field
//                   decoration: const InputDecoration(
//                     labelText: 'BIN',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your BIN';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         try {
//                           final updatedSeller = SellerEntity(
//                             id: authState.userInfo!
//                                 .id, // Assuming you have an 'id' in your SellerEntity
//                             deleted: authState.userInfo!.deleted,
//                             created: authState.userInfo!.created,
//                             bin: _binController
//                                 .text, // Get bin from the controller
//                             email: authState.userInfo!.email,
//                             firstName: _firstNameController.text,
//                             lastName: _lastNameController.text,
//                             phone: _phoneController.text,
//                             iin: _iinController.text,
//                             gender: selectedGender,
//                             companyType: authState.userInfo!.companyType,
//                             approved: authState.userInfo!.approved,
//                           );
//
//                           // Update the user profile in the repository
//                           await sellerRepository.updateSellerInformation(
//                             jwt: authState.token, // Pass the JWT from authState
//                             bin: _binController
//                                 .text, // Pass bin to the repository
//                             firstName: _firstNameController.text,
//                             lastName: _lastNameController.text,
//                             phone: _phoneController.text,
//                             iin: _iinController.text,
//                             gender: selectedGender!,
//                           );
//
//                           // Update the auth state
//                           authStateNotifier.updateUserInfo(updatedSeller);
//
//                           // Show success snackbar
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Profile updated')),
//                           );
//
//                           // Navigate back to the previous screen
//                           context.pop();
//                         } catch (e) {
//                           // Handle update error
//                           print('Update failed: $e');
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Update failed')),
//                           );
//                         }
//                       }
//                     },
//                     child: const Text('Update Profile'),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:elbazar_app/data/models/address_model.dart';
import 'package:elbazar_app/data/models/city_model.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/users_model/admin_model.dart';
import '../../../data/models/users_model/customer_model.dart';
import '../../../data/models/users_model/seller_model.dart';
import '../../provider/products_repo_provider.dart';

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

  AddressModel? _address;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = ref.read(authStateProvider);

    if (authState.userInfo is SellerModel) {
      final seller = authState.userInfo as SellerModel;
      _firstNameController.text = seller.firstName;
      _lastNameController.text = seller.lastName;
      _phoneController.text = seller.phone;
      _iinController.text = seller.iin;
      _binController.text = seller.bin;
      selectedGender = seller.gender;
    } else if (authState.userInfo is CustomerModel) {
      final customer = authState.userInfo as CustomerModel;
      _firstNameController.text = customer.firstName;
      _lastNameController.text = customer.lastName;
      _phoneController.text = customer.phone;
      _iinController.text = customer.iin;
      selectedGender = customer.gender;
      _address = customer.address;
    } else if (authState.userInfo is AdminModel) {
      // Logic for Admin if required
    }
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
    final authState = ref.watch(authStateProvider);
    final authStateNotifier = ref.watch(authStateProvider.notifier);
    final sellerRepository = ref.watch(sellerRepositoryProvider);

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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                if (authState.userInfo is SellerModel)
                  const SizedBox(height: 12),
                if (authState.userInfo is SellerModel)
                  TextFormField(
                    controller: _iinController,
                    maxLength: 12,
                    decoration: const InputDecoration(labelText: 'IIN'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your IIN';
                      }
                      return null;
                    },
                  ),
                if (authState.userInfo is SellerModel)
                  const SizedBox(height: 12),
                if (authState.userInfo is SellerModel)
                  TextFormField(
                    controller: _binController,
                    maxLength: 12,
                    decoration: const InputDecoration(labelText: 'BIN'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your BIN';
                      }
                      return null;
                    },
                  ),
                if (authState.userInfo is CustomerModel)
                  const SizedBox(height: 12),
                if (authState.userInfo is CustomerModel)
                  // _buildAddressFields(context),
                  const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (authState.userInfo is SellerModel) {
                            final updatedSeller = SellerModel(
                              id: (authState.userInfo as SellerModel).id,
                              deleted:
                                  (authState.userInfo as SellerModel).deleted,
                              created:
                                  (authState.userInfo as SellerModel).created,
                              bin: _binController.text,
                              email: (authState.userInfo as SellerModel).email,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phone: _phoneController.text,
                              iin: _iinController.text,
                              gender: selectedGender!,
                              companyType: (authState.userInfo as SellerModel)
                                  .companyType,
                              approved:
                                  (authState.userInfo as SellerModel).approved,
                            );

                            // Update the seller profile in the repository
                            await sellerRepository.updateSellerInformation(
                              jwt: authState.token,
                              bin: _binController.text,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phone: _phoneController.text,
                              iin: _iinController.text,
                              gender: selectedGender!,
                            );

                            // Update the auth state
                            authStateNotifier.updateUserInfo(updatedSeller);
                          } else if (authState.userInfo is CustomerModel) {
                            final updatedCustomer = CustomerModel(
                              id: (authState.userInfo as CustomerModel).id,
                              deleted:
                                  (authState.userInfo as CustomerModel).deleted,
                              created:
                                  (authState.userInfo as CustomerModel).created,
                              email:
                                  (authState.userInfo as CustomerModel).email,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              phone: _phoneController.text,
                              iin: _iinController.text,
                              gender: selectedGender!,
                              address: _address!,
                            );

                            // Update the auth state
                            authStateNotifier.updateUserInfo(updatedCustomer);
                          }

                          // Show success snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated')),
                          );

                          // Navigate back to the previous screen
                          context.pop();
                        } catch (e) {
                          // Handle update error
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

//   Widget _buildAddressFields(BuildContext context) {
//     final streetController = TextEditingController(text: _address?.street);
//     final cityController = TextEditingController(text: _address!.city);
//     final zipCodeController = TextEditingController(text: _address?.zipCode);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Address',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         const SizedBox(height: 12),
//         _buildTextField(
//           controller: streetController,
//           label: 'Street',
//           validatorMessage: 'Please enter your street',
//         ),
//         const SizedBox(height: 12),
//         _buildTextField(
//           controller: cityController,
//           label: 'City',
//           validatorMessage: 'Please enter your city',
//         ),
//         const SizedBox(height: 12),
//         _buildTextField(
//           controller: zipCodeController,
//           label: 'Zip Code',
//           validatorMessage: 'Please enter your zip code',
//         ),
//         const SizedBox(height: 12),
//         Center(
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//             ),
//             onPressed: () {
//               setState(() {
//                 _address = AddressModel(
//                   street: streetController.text,
//                   city: CityModel(created: DateTime.now(), ),
//                   id: 0,
//                   deleted: false,
//                   created: DateTime.now(),
//                   region: '',
//                   house: '',
//                   apartments: '',
//                   fullAddress: '',
//                 );
//               });
//             },
//             child: const Text('Update Address'),
//           ),
//         ),
//       ],
//     );
//   }
}
