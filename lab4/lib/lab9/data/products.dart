import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

const String productsUrl = 'https://fakestoreapi.com/products';

Future<List<Product>> fetchProducts() async {
  try {
    final response = await http
        .get(Uri.parse(productsUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 404) {
      throw Exception('Ошибка 404: товары не найдены на сервере');
    } else if (response.statusCode >= 500) {
      throw Exception('Ошибка ${response.statusCode}: сервер недоступен');
    } else {
      throw Exception('Ошибка ${response.statusCode}');
    }
  } on TimeoutException {
    throw Exception('Сервер не ответил за 10 секунд');
  } on http.ClientException {
    throw Exception('Нет подключения к интернету');
  } on FormatException {
    throw Exception('Сервер прислал неверные данные');
  }
}
