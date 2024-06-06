// import 'package:elbazar_app/presentation/provider/admin_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final changeSellerStatus =
//     FutureProvider.family<dynamic, Map<String, dynamic>>((ref, sellerParams) {
//   final adminRepository = ref.watch(adminRepositoryProvider);
//   return adminRepository.changeSalesStatus(
//     bin: sellerParams['bin'],
//     isApproved: sellerParams['isApproved'],
//   );
// });

// final getDocumentsList =
//     FutureProvider.family<dynamic, Map<String, dynamic>>((ref, docParams) {
//   final adminRepository = ref.watch(adminRepositoryProvider);
//   return adminRepository.getDocuments(
//       page: docParams['page'],
//       size: docParams['size'],
//       sort: docParams['sort'],
//       order: docParams['order'],
//       bin: docParams['bin']);
// });

// class AdminSellerDocuments extends ConsumerStatefulWidget {
//   const AdminSellerDocuments({super.key, required this.sellerInfo});
//   final dynamic sellerInfo;

//   @override
//   _AdminSellerDocuments createState() => _AdminSellerDocuments();
// }

// class _AdminSellerDocuments extends ConsumerState<AdminSellerDocuments> {
//   dynamic sellerInfo;
//   late bool sellerIsApproved;
//   late Map<String, dynamic> sellerParams;
//   late Map<String, dynamic> docParams;

//   @override
//   void initState() {
//     sellerInfo = widget.sellerInfo;
//     sellerIsApproved = sellerInfo['approved'];
//     sellerParams = {
//       'bin': sellerInfo['bin'],
//       'isApproved': sellerIsApproved,
//     };
//     super.initState();
//   }

//   void _updateSellerStatus(bool isApproved) {
//     setState(() {
//       sellerIsApproved = isApproved;
//       sellerParams['isApproved'] = isApproved;
//     });

//     ref.read(changeSellerStatus(sellerParams).future).then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           isApproved ? 'Seller Approved' : 'Seller Disapproved',
//         ),
//       ));
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to update status: $error'),
//       ));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Documents'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'approve') {
//                 _updateSellerStatus(true);
//                 setState(() {
//                   sellerIsApproved = true;
//                 });
//               } else if (value == 'disapprove') {
//                 _updateSellerStatus(false);
//                 setState(() {
//                   sellerIsApproved = false;
//                 });
//               }
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               PopupMenuItem<String>(
//                 value: 'approve',
//                 child: Text('Approve Seller'),
//               ),
//               PopupMenuItem<String>(
//                 value: 'disapprove',
//                 child: Text('Disapprove Seller'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Card(
//         elevation: 6,
//         margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Row(children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'User Profile',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 _buildField('BIN', sellerInfo['bin'].toString()),
//                 _buildField('Name',
//                     '${sellerInfo['firstName']} ${sellerInfo['lastName']}'),
//                 _buildField('Email', sellerInfo['email']),
//                 _buildField('Phone', sellerInfo['phone'] ?? 'Not Available'),
//                 _buildField('Gender', sellerInfo['gender'] ?? 'Not Available'),
//                 _buildField('Company Type', sellerInfo['companyType']),
//                 _buildField('Approved', sellerIsApproved ? 'Yes' : 'No'),
//               ],
//             ),
//             Expanded(
//               child: Column(
//                 children: [Center(child: Text("Center"))],
//               ),
//             )
//           ]),
//         ),
//       ),
//     );
//   }

//   Widget _buildField(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[800],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:elbazar_app/presentation/provider/admin_provider.dart';
import 'package:elbazar_app/presentation/screens/admin_functional/document_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

final changeSellerStatus =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, sellerParams) {
  final adminRepository = ref.watch(adminRepositoryProvider);
  return adminRepository.changeSalesStatus(
    bin: sellerParams['bin'],
    isApproved: sellerParams['isApproved'],
  );
});

final getDocumentsList =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, docParams) {
  final adminRepository = ref.watch(adminRepositoryProvider);
  return adminRepository.getDocuments(
      page: docParams['page'],
      size: docParams['size'],
      sort: docParams['sort'],
      order: docParams['order'],
      bin: docParams['bin']);
});

class AdminSellerDocuments extends ConsumerStatefulWidget {
  const AdminSellerDocuments({super.key, required this.sellerInfo});
  final dynamic sellerInfo;

  @override
  _AdminSellerDocuments createState() => _AdminSellerDocuments();
}

class _AdminSellerDocuments extends ConsumerState<AdminSellerDocuments> {
  dynamic sellerInfo;
  late bool sellerIsApproved;
  late Map<String, dynamic> sellerParams;
  final int _pageSize = 10; // Adjust as needed
  late PagingController<int, dynamic> _pagingController;

  @override
  void initState() {
    sellerInfo = widget.sellerInfo;
    sellerIsApproved = sellerInfo['approved'];
    sellerParams = {
      'bin': sellerInfo['bin'],
      'isApproved': sellerIsApproved,
    };
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await ref.read(getDocumentsList(
        {
          'page': pageKey,
          'size': _pageSize,
          'sort': 'id', // Replace with your desired sorting
          'order': 'ASC', // Replace with ASC or DESC
          'bin': sellerInfo['bin'],
        },
      ).future);

      final newItems = response;
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

  void _updateSellerStatus(bool isApproved) {
    setState(() {
      sellerIsApproved = isApproved;
      sellerParams['isApproved'] = isApproved;
    });

    ref.read(changeSellerStatus(sellerParams).future).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          isApproved ? 'Seller Approved' : 'Seller Disapproved',
        ),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update status: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'approve') {
                _updateSellerStatus(true);
                setState(() {
                  sellerIsApproved = true;
                });
              } else if (value == 'disapprove') {
                _updateSellerStatus(false);
                setState(() {
                  sellerIsApproved = false;
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'approve',
                child: Text('Approve Seller'),
              ),
              PopupMenuItem<String>(
                value: 'disapprove',
                child: Text('Disapprove Seller'),
              ),
            ],
          ),
        ],
      ),
      body: Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildField('BIN', sellerInfo['bin'].toString()),
                _buildField('Name',
                    '${sellerInfo['firstName']} ${sellerInfo['lastName']}'),
                _buildField('Email', sellerInfo['email']),
                _buildField('Phone', sellerInfo['phone'] ?? 'Not Available'),
                _buildField('Gender', sellerInfo['gender'] ?? 'Not Available'),
                _buildField('Company Type', sellerInfo['companyType']),
                _buildField('Approved', sellerIsApproved ? 'Yes' : 'No'),
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: PagedListView<int, dynamic>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  itemBuilder: (context, item, index) {
                    final docInfo = item;
                    return Card(
                      child: ListTile(
                        leading: Text('#${docInfo['id']}'),
                        title: Text(docInfo['name']),
                        subtitle: Text(
                          docInfo['contentType'],
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentWebView(docInfo: docInfo),)),
                      ),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
