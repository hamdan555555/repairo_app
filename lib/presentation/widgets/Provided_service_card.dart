import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProvidedServiceCard extends StatelessWidget {
  final String? title;
  final String? description;
  final List<String>? images;

  const ProvidedServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (images != null && images!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 180,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                  ),
                  items: images!.map((imageUrl) {
                    return Image.network(
                      imageUrl.replaceFirst(
                          "127.0.0.1", AppConstants.baseaddress),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
