import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiException implements Exception {
  final String title;
  final String message;

  const ApiException(this.title, this.message);

  @override
  String toString() => '$title: $message';
}

class ProductService {
  static const _url = 'https://fakestoreapi.com/products';
  static const _timeout = Duration(seconds: 10);

  final http.Client _client;

  ProductService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(Uri.parse(_url)).timeout(_timeout);

      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body) as List<dynamic>;
          return data
              .whereType<Map<String, dynamic>>()
              .map(Product.fromJson)
              .toList();
        case 404:
          throw const ApiException(
              'Ошибка 404', 'Каталог не найден на сервере.');
        case >= 500:
          throw ApiException('Ошибка ${response.statusCode}',
              'Сервер временно недоступен. Попробуйте позже.');
        default:
          throw ApiException('Ошибка ${response.statusCode}',
              'Сервер вернул неожиданный ответ.');
      }
    } on TimeoutException {
      throw const ApiException('Превышено время ожидания',
          'Сервер не ответил за 10 секунд. Проверьте соединение.');
    } on http.ClientException {
      throw const ApiException('Нет подключения',
          'Проверьте интернет или выключите авиарежим и повторите попытку.');
    } on FormatException {
      throw const ApiException(
          'Ошибка данных', 'Не удалось разобрать ответ сервера.');
    } on TypeError {
      throw const ApiException(
          'Ошибка данных', 'Сервер прислал данные в неверном формате.');
    }
  }

  void dispose() => _client.close();
}
