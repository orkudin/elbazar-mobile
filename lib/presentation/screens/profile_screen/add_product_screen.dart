import 'dart:io';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/categories_screen/categories_screen.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/my_products_screen/seller_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final productDataProvider = StateProvider<Map<String, dynamic>>((ref) => {
      'name': '',
      'description': '',
      'price': 0.0,
      'quantity': 0,
      'categoryId': 0,
      'images': <File>[],
    });

final selectedCategoryNameProvider = StateProvider<String>((ref) => 'Category');

// ignore: must_be_immutable
class UploadProductScreen extends ConsumerWidget {
  dynamic selectedCategory;

  UploadProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productData = ref.watch(productDataProvider);
    final sellerRepository = ref.read(sellerRepositoryProvider);
    final authState = ref.watch(authStateProvider);
    final selectedCategoryName = ref.watch(selectedCategoryNameProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['name'] = value;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['description'] =
                    value;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['price'] =
                    double.parse(value);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['quantity'] =
                    int.parse(value);
              },
            ),
            const SizedBox(height: 16.0),
            Row(children: [
              TextButton(
                  onPressed: () async {
                    selectedCategory = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoriesScreen(
                            previousScreen: 'add_product',
                          ),
                        ));
                    ref.read(productDataProvider.notifier).state['categoryId'] =
                        selectedCategory.id;
                    ref.read(selectedCategoryNameProvider.notifier).state =
                        selectedCategory.name;
                    print("3------------- ${selectedCategory.name}");
                  },
                  child: Text('Select a category:')),
              Expanded(
                  child: Row(children: [
                Container(
                    padding: EdgeInsets.all(12),
                    color: Colors.amber,
                    child: Text('$selectedCategoryName'))
              ]))
            ]),
            const SizedBox(height: 16.0),
            const Text('Product Images (max 4)'),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                for (var i = 0; i < 4; i++)
                  _buildImageContainer(context, ref, i, productData),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Upload product
                await sellerRepository
                    .uploadProduct(
                  jwt: authState.token,
                  name: productData['name'],
                  description: productData['description'],
                  price: productData['price'],
                  quantity: productData['quantity'],
                  categoryId: productData['categoryId'],
                )
                    .then((responseData) async {
                  final productId = responseData['id'];

                  // Upload product images
                  final imagePaths = productData['images']
                      .map((file) => file.path)
                      .toList()
                      .cast<String>();
                  await sellerRepository
                      .uploadProductImages(
                    jwt: authState.token,
                    productId: productId,
                    imageFilePaths: imagePaths,
                  )
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Product uploaded successfully')),
                    );
                    Navigator.pop(context);
                    ref.invalidate(productsWithImagesProvider);
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Failed to upload product images')),
                    );
                  });
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to upload product')),
                  );
                });
              },
              child: const Text('Upload Product'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(
      BuildContext context, WidgetRef ref, int index, productData) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            try {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                final images =
                    ref.read(productDataProvider.notifier).state['images'];
                if (images.length < 4) {
                  images.add(File(pickedFile.path));
                  ref.read(productDataProvider.notifier).state = {
                    ...productData,
                    'images': images,
                  };
                }
              }
            } catch (e) {
              print(e);
            }
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: productData['images'].length > index
                ? Image.file(productData['images'][index], fit: BoxFit.cover)
                : Icon(Icons.add_a_photo),
          ),
        ),
        if (productData['images'].length > index)
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                final images =
                    ref.read(productDataProvider.notifier).state['images'];
                images.removeAt(index);
                ref.read(productDataProvider.notifier).state = {
                  ...productData,
                  'images': images,
                };
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
