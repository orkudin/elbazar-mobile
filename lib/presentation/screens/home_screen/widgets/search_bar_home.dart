import 'package:elbazar_app/config/constatnts/colors.dart';
import 'package:elbazar_app/config/constatnts/sizes.dart';
import 'package:flutter/material.dart';

class SearchBarHome extends StatefulWidget {
  const SearchBarHome({
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

class _SearchBarHomeState extends State<SearchBarHome> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: CustomSizes.defaultSpace),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
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
            Icon(widget.icon, color: CustomColors.black),
            SizedBox(width: CustomSizes.spaceBtwItems),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                onSubmitted: widget.onSearch,
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: CustomColors.black),
              onPressed: () => widget.onSearch(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}
