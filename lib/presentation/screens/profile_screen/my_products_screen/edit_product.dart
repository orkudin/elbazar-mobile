import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/network/entity/product_with_images.dart';

final productWithImagesByIdProvider =
    FutureProvider.family<ProductWithImages, int>((ref, productId) async {
  final sellerApiClient = ref.read(sellerApiClientProvider);
  return await sellerApiClient.getProductWithImagesById(productId: productId);
});

class EditProductScreen extends ConsumerStatefulWidget {
  const EditProductScreen({Key? key, required this.productId})
      : super(key: key);

  final int productId;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _categoryIdController;

  late bool _active; // For the 'active' boolean field

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _categoryIdController = TextEditingController();

    _active = true; // Default value for active

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(productWithImagesByIdProvider(widget.productId).future)
          .then((product) {
        _nameController.text = product.name;
        _descriptionController.text = product.description!;
        _priceController.text = product.price.toString();
        _quantityController.text = product.quantity.toString();
        _categoryIdController.text = product.categoryName;
        _active = product.active;
        setState(() {}); // Update the UI with the product values
      }).catchError((error) {
        print('Error fetching product: $error');
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _categoryIdController.dispose();
    super.dispose();
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      final sellerApiClient = ref.read(sellerApiClientProvider);
      final authState = ref.watch(authStateProvider);

      sellerApiClient.updateProduct(
          jwt: authState.token,
          productId: widget.productId,
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          active: _active,
          quantity: int.parse(_quantityController.text),
          categoryId: 2);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue =
        ref.watch(productWithImagesByIdProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: asyncValue.when(
        data: (product) => _buildProductForm(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildProductForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a product name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a product description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              final numValue = num.tryParse(value);
              if (numValue == null || numValue <= 0) {
                return 'Please enter a valid price greater than zero';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Active'),
            value: _active,
            onChanged: (newValue) {
              setState(() {
                _active = newValue;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a quantity';
              }
              final intValue = int.tryParse(value);
              if (intValue == null || intValue < 0) {
                return 'Please enter a valid quantity';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _categoryIdController,
            decoration: const InputDecoration(
              labelText: 'Category ID',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category ID';
              }
              final intValue = int.tryParse(value);
              if (intValue == null || intValue <= 0) {
                return 'Please enter a valid category ID';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _updateProduct,
            child: const Text('Update Product'),
          ),
        ],
      ),
    );
  }
}
