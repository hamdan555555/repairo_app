// import 'package:breaking_project/data/models/service_model.dart';

// class CartItem {
//   final RServiceData service;
//   int quantity;

//   CartItem({required this.service, this.quantity = 1});
// }

// class Cart {
//   List<CartItem> items = [];

//   // في كلاس Cart
//   bool contains(RServiceData service) {
//     return items.any((item) => item.service.id == service.id);
//   }

//   /// إضافة خدمة أو زيادة كميتها
//   void add(RServiceData service) {
//     final index = items.indexWhere((item) => item.service.id == service.id);
//     if (index >= 0) {
//       items[index].quantity++;
//     } else {
//       items.add(CartItem(service: service));
//     }
//   }

//   /// إنقاص الكمية (ولو وصلت صفر بينحذف من الكارت)
//   void decrement(RServiceData service) {
//     final index = items.indexWhere((item) => item.service.id == service.id);
//     if (index >= 0) {
//       if (items[index].quantity > 1) {
//         items[index].quantity--;
//       } else {
//         items.removeAt(index);
//       }
//     }
//   }

//   /// حذف الخدمة بالكامل
//   void remove(RServiceData service) {
//     items.removeWhere((item) => item.service.id == service.id);
//   }

//   /// تجيب الكمية الخاصة بخدمة
//   int getQuantity(RServiceData service) {
//     final index = items.indexWhere((item) => item.service.id == service.id);
//     if (index >= 0) {
//       return items[index].quantity;
//     }
//     return 0;
//   }

//   /// السعر الإجمالي
//   double get total => items.fold(
//       0,
//       (sum, item) =>
//           sum + double.parse(item.service.maxPrice ?? '0') * item.quantity);

//   bool get isEmpty => items.isEmpty;
//   bool get isNotEmpty => items.isNotEmpty;
// }

import 'package:breaking_project/data/models/base_service_model.dart';
import 'package:breaking_project/data/models/provided_services.dart';
import 'package:breaking_project/data/models/service_model.dart';

class CartItem {
  final BaseService service;
  int quantity;

  CartItem({required this.service, this.quantity = 1});
}

class Cart {
  List<CartItem> items = [];

  bool contains(BaseService service) {
    return items.any((item) => item.service.id == service.id);
  }

  RProvidedServices convertToProvidedService(RServiceData service) {
    return RProvidedServices(
      id: service.id,
      serviceName: service.name,
      servicePrice: service.price, // أو service.basePrice إذا عندك هيك
      // إذا في حقول إضافية بـ RProvidedService مو موجودة بـ RService
      // ممكن تحط قيم افتراضية أو تجيبها من مكان تاني
      // هون عبيها حسب الحاجة
    );
  }

  void add(BaseService service) {
    final index = items.indexWhere((item) => item.service.id == service.id);
    if (index >= 0) {
      items[index].quantity++;
    } else {
      items.add(CartItem(service: service));
    }
  }

  void decrement(BaseService service) {
    final index = items.indexWhere((item) => item.service.id == service.id);
    if (index >= 0) {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      } else {
        items.removeAt(index);
      }
    }
  }

  void remove(BaseService service) {
    items.removeWhere((item) => item.service.id == service.id);
  }

  int getQuantity(BaseService service) {
    final index = items.indexWhere((item) => item.service.id == service.id);
    if (index >= 0) {
      return items[index].quantity;
    }
    return 0;
  }

  double get total =>
      items.fold(0, (sum, item) => sum + item.service.price * item.quantity);

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}
