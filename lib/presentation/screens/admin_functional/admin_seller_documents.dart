import 'package:elbazar_app/presentation/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changeSellerStatus =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) {
  final adminRepository = ref.watch(adminRepositoryProvider);
  return adminRepository.changeSalesStatus(
    bin: params['bin'],
    isApproved: params['isApproved'],
  );
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
  late Map<String, dynamic> _params;

  @override
  void initState() {
    sellerInfo = widget.sellerInfo;
    sellerIsApproved = sellerInfo['approved'];
    _params = {
      'bin': sellerInfo['bin'],
      'isApproved': sellerIsApproved,
    };
    super.initState();
  }

  void _updateSellerStatus(bool isApproved) {
    setState(() {
      sellerIsApproved = isApproved;
      _params['isApproved'] = isApproved;
    });

    ref.read(changeSellerStatus(_params).future).then((value) {
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
