import 'package:breaking_project/data/models/service_model.dart';

class CartItem {
  final RServiceData service;
  int quantity;

  CartItem({required this.service, this.quantity = 1});
}

class Cart {
  List<CartItem> items = [];

  /// إضافة خدمة أو زيادة كميتها
  void add(RServiceData service) {
    final index = items.indexWhere((item) => item.service.id == service.id);
    if (index >= 0) {
      items[index].quantity++;
    } else {
      items.add(CartItem(service: service));
    }
  }

  /// إنقاص الكمية (ولو وصلت صفر بينحذف من الكارت)
  void decrement(RServiceData service) {
    final index = items.indexWhere((item) => item.service.id == service.id);
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
    }
  }

  /// حذف الخدمة بالكامل
  void remove(RServiceData service) {
    items.removeWhere((item) => item.service.id == service.id);
  }

  /// تجيب الكمية الخاصة بخدمة
  int getQuantity(RServiceData service) {
    final index = items.indexWhere((item) => item.service.id == service.id);
    if (index >= 0) {
      return items[index].quantity;
    }
    return 0;
  }

  /// السعر الإجمالي
  double get total => items.fold(
      0,
      (sum, item) =>
          sum + double.parse(item.service.maxPrice ?? '0') * item.quantity);

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}
