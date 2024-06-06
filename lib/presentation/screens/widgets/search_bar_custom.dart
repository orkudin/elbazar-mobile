import 'package:elbazar_app/config/theme/constatnts/colors.dart';
import 'package:elbazar_app/config/theme/constatnts/sizes.dart';
import 'package:flutter/material.dart';

class SearchBarCustom extends StatefulWidget {
  const SearchBarCustom({
    Key? key,
    required this.onSearch,
    this.icon = Icons.search,
    this.showBackground = true,
    this.showBorder = true,
  }) : super(key: key);

  final Function(String) onSearch;
  final IconData? icon;
  final bool showBackground, showBorder;

  @override
  _SearchBarHomeState createState() => _SearchBarHomeState();
}

class _SearchBarHomeState extends State<SearchBarCustom> {
  final TextEditingController _searchValueController = TextEditingController();
  @override
  void dispose() {
    _searchValueController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(
          right: CustomSizes.defaultSpace,
          left: CustomSizes.defaultSpace,
          bottom: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.showBackground
              ? dark
                  ? CustomColors.dark
                  : CustomColors.light
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border:
              widget.showBorder ? Border.all(color: CustomColors.grey) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchValueController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                onSubmitted: widget.onSearch,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: CustomColors.black),
              onPressed: () {
                widget.onSearch(_searchValueController.text);
                _searchValueController.text = '';
              },
            ),
          ],
        ),
      ),
    );
  }
}
