import 'dart:typed_data';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider(
      {super.key, required this.imagesBytes, required this.options});
  final List<Uint8List> imagesBytes;
  final CarouselOptions options;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: imagesBytes.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            // Hero(
            // tag: imagesUrl[itemIndex],
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: MemoryImage(imagesBytes[itemIndex]),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                imageErrorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'Нет изображения',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        // ),
        options: options);
  }
}
