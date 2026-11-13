import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'product_image.dart';

class PhotoCarousel extends StatefulWidget {
  final List<String> images;
  final String heroTag;

  const PhotoCarousel({super.key, required this.images, required this.heroTag});

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: PointerDeviceKind.values.toSet(),
                  ),
                  itemCount: total,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, index) {
                    final image = ProductImage(url: widget.images[index]);
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: index == 0
                          ? Hero(tag: widget.heroTag, child: image)
                          : image,
                    );
                  },
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_page + 1} / $total',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < total; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _page ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? FlipColors.blue
                          : FlipColors.grey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
