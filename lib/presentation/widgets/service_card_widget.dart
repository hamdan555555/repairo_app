import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/provided_services.dart';
import 'package:breaking_project/presentation/screens/provided_services.dart';
import 'package:flutter/material.dart';

// class ServiceCard extends StatefulWidget {
//   final RProvidedServices service;

//   const ServiceCard({super.key, required this.service});

//   @override
//   State<ServiceCard> createState() => _ServiceCardState();
// }

// class _ServiceCardState extends State<ServiceCard> {
//   @override
//   Widget build(BuildContext context) {
//     bool isSelected = false;

//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(12),
//         leading: CircleAvatar(
//           radius: 30,
//           backgroundImage: NetworkImage(
//             widget.service.image!
//                 .replaceFirst('127.0.0.1', AppConstants.baseaddress),
//           ),
//         ),
//         title: Text(
//           "السعر: ${widget.service.price} ل.س",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//             "النطاق السعري: ${widget.service.minPrice} - ${widget.service.maxPrice} ل.س"),
//         trailing: Checkbox(
//           value: widget.service.selected == true ? !isSelected : isSelected,
//           shape: const CircleBorder(), // خلي شكلها دائرة
//           activeColor: Colors.deepPurple,
//           onChanged: (val) {
//             setState(() {
//               isSelected = val!;
//               //final cubit = context.read<HomeCubit>();

//               // ProvidedServicesScreen.(
//               //     widget.services.id!, isSelected);
//               // cubit.toggleServiceSelection(
//               //     widget.services.id!, isSelected);
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

class ServiceCard extends StatefulWidget {
  final RProvidedServices service;
  final bool isSelected;
  final Function(String serviceId, bool selected) onToggle;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
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
          backgroundImage: NetworkImage(
            widget.service.image!
                .replaceFirst('127.0.0.1', AppConstants.baseaddress),
          ),
        ),
        title: Text(
          "الخدمة: ${widget.service.name}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(" السعر: ${widget.service.price} ل.س"),
        trailing: Checkbox(
          value: widget.isSelected,
          shape: const CircleBorder(),
          activeColor: Colors.deepPurple,
          onChanged: (val) {
            setState(() {
              widget.onToggle(widget.service.id!, val!);
            });
          },
        ),
      ),
    );
  }
}
