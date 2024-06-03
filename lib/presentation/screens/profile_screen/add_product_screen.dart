import 'dart:io';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
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

class UploadProductScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productData = ref.watch(productDataProvider);
    final sellerRepository = ref.read(sellerRepositoryProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['name'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['description'] =
                    value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['price'] =
                    double.parse(value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['quantity'] =
                    int.parse(value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Category ID'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref.read(productDataProvider.notifier).state['categoryId'] =
                    int.parse(value);
              },
            ),
            SizedBox(height: 16.0),
            Text('Product Images (max 4)'),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                for (var i = 0; i < 4; i++)
                  GestureDetector(
                    onTap: () async {
                      try {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          final images = ref
                              .read(productDataProvider.notifier)
                              .state['images'];
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
                      child: productData['images'].length > i
                          ? Image.file(productData['images'][i],
                              fit: BoxFit.cover)
                          : Icon(Icons.add_a_photo),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Upload product
                final response = await sellerRepository
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
                  final imageResponse = await sellerRepository
                      .uploadProductImages(
                    jwt: authState.token,
                    productId: productId,
                    imageFilePaths: imagePaths,
                  )
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Product uploaded successfully')),
                    );
                    Navigator.pop(context);
                    ref.invalidate(productsWithImagesProvider);
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to upload product images')),
                    );
                  });
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload product')),
                  );
                });
              },
              child: Text('Upload Product'),
            ),
          ],
        ),
      ),
    );
  }
}
