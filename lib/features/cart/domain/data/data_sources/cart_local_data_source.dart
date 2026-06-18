import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../product/data/models/product_model.dart';
import '../../entities/cart_item.dart';

abstract class CartLocalDataSource {
  Future<List<CartItem>> getCartItems();
  Future<void> saveCartItems(List<CartItem> items);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box _cartBox = Hive.box('cart_box');
  static const String _cartKey = 'cached_cart_items';

  @override
  Future<List<CartItem>> getCartItems() async {
    final String? jsonString = _cartBox.get(_cartKey);
    if (jsonString == null) return [];

    final List<dynamic> decodedList = json.decode(jsonString);
    return decodedList.map((item) {
      return CartItem(
        product: ProductModel.fromJson(item['product']),
        quantity: item['quantity'] as int,
      );
    }).toList();
  }

  @override
  Future<void> saveCartItems(List<CartItem> items) async {
    final List<Map<String, dynamic>> rawList = items.map((item) {
      return {
        'product': (item.product as ProductModel).toJson(),
        'quantity': item.quantity,
      };
    }).toList();

    await _cartBox.put(_cartKey, json.encode(rawList));
  }
}