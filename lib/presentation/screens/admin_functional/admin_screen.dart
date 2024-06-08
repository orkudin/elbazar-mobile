import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/screens/admin_functional/admin_seller_documents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/presentation/provider/admin_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

final adminGetAllSellersProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) {
  final adminRepository = ref.watch(adminRepositoryProvider);
  return adminRepository.getSales(
    page: params['page'],
    size: params['size'],
    sort: params['sort'],
    order: params['order'],
    isApproved: params['isApproved'],
  );
});

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  bool _isApproved = true;
  String _order = 'ASC';
  String _sort = 'id';
  final int _pageSize = 10;
  late PagingController<int, dynamic> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final responseAsyncGetSellers = await ref.watch(
        adminGetAllSellersProvider(
          {
            'page': pageKey,
            'size': _pageSize,
            'sort': _sort,
            'order': _order,
            'isApproved': _isApproved,
          },
        ).future, // Correctly access the future here
      );

      final newItems = responseAsyncGetSellers;
      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _updateParams() {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        actions: [
          TextButton(
              onPressed: () {
               
                context.go('/login'); 
                ref.watch(authStateProvider.notifier).logout();
              },
              child: Text('Log out'))
        ],
      ),
      body: Column(
        children: [
          filterSellers(),
          Expanded(
            child: PagedListView<int, dynamic>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<dynamic>(
                itemBuilder: (context, item, index) {
                  final sellerInfo = item;
                  return ListTile(
                    leading: Text('#${sellerInfo['id']}'),
                    title: Text(
                        '${sellerInfo['firstName']} ${sellerInfo['lastName']}'),
                    subtitle: Text(
                      'Bin: ${sellerInfo['bin']}\nCreated: ${DateTime.parse(sellerInfo['created'])}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: _buildApprovedIcon(sellerInfo['approved']),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AdminSellerDocuments(sellerInfo: sellerInfo),
                        )),
                  );
                },
                firstPageProgressIndicatorBuilder: (context) =>
                    const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row filterSellers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownButton<bool>(
          value: _isApproved,
          items: const [
            DropdownMenuItem(
              value: true,
              child: Text('Approved'),
            ),
            DropdownMenuItem(
              value: false,
              child: Text('Not Approved'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _isApproved = value!;
              _updateParams();
            });
          },
        ),
        DropdownButton<String>(
          value: _order,
          items: ['ASC', 'DESC'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _order = value!;
              _updateParams();
            });
          },
        ),
        DropdownButton<String>(
          value: _sort,
          items: ['id', 'bin', 'created', 'firstName', 'lastName']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.toLowerCase()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _sort = value!;
              _updateParams();
            });
          },
        ),
      ],
    );
  }

  Widget _buildApprovedIcon(bool approved) {
    if (approved) {
      return const Icon(Icons.check, color: Colors.green);
    } else {
      return const Icon(Icons.close, color: Colors.red);
    }
  }
}
