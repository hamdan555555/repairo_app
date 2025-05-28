import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/items_model.dart';
import 'package:breaking_project/data/models/service_model.dart';
import 'package:breaking_project/presentation/screens/services_screen.dart';
import 'package:flutter/material.dart';

class ServicesWidget extends StatefulWidget {
  final RServiceData services;
  final int indexx;
  final void Function(String serviceId, bool selected) onToggle;

  const ServicesWidget({
    super.key,
    required this.services,
    required this.indexx,
    required this.onToggle,
  });

  @override
  State<ServicesWidget> createState() => _ServicesWidgetState();
}

class _ServicesWidgetState extends State<ServicesWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          // صورة الخدمة
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Image.network(
                  widget.services.image!
                      .replaceFirst('127.0.0.1', AppConstants.baseaddress),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported_outlined,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                ),

                // Image.asset(
                //   'assets/images/png/worker1.png',
                //   height: 100,
                //   width: 100,
                //   fit: BoxFit.cover,
                // ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.services.maxPrice!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // معلومات الخدمة
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) =>
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.services.displayName!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage:
                          AssetImage("assets/images/png/worker1.png"),
                    ),
                    SizedBox(width: 8),
                    Text("provider"),
                  ],
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Checkbox(
              value: isSelected,
              shape: const CircleBorder(),
              activeColor: Colors.deepPurple,
              onChanged: (val) {
                setState(() {
                  isSelected = val!;
                  widget.onToggle(widget.services.id!, isSelected);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
