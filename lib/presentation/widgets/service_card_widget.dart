import 'package:breaking_project/data/models/provided_services.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final RProvidedServices service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 30,
          // backgroundImage: NetworkImage(service.i),
        ),
        title: Text(
          "السعر: ${service.price} ل.س",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            "النطاق السعري: ${service.minPrice} - ${service.maxPrice} ل.س"),
        trailing: service.selected!
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const SizedBox.shrink(),
      ),
    );
  }
}
