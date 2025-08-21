import 'package:breaking_project/presentation/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';

class CartBottomSheet extends StatelessWidget {
  final Cart cart;

  CartBottomSheet({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 200,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("مجموع: ${cart.total} درهم",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () {
                  // الانتقال للخطوة التالية
                },
                child: Text("التالي"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.service.displayName!),
                  subtitle: Text("x${item.quantity}"),
                  trailing: Text(
                      "${double.parse(item.service.maxPrice!) * item.quantity} درهم"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
