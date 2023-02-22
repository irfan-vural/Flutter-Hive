import 'dart:io';

import 'package:dio/dio.dart';

import '../model/user_model.dart';

abstract class IHomeService {
  late final Dio _dio;

  IHomeService(Dio dio) {
    _dio = dio;
  }

  Future<List<user_model>?> fetchUsers();
}

final _userPath = '/users';

class HomeService extends IHomeService {
  HomeService(super.dio);

  @override
  Future<List<user_model>?> fetchUsers() async {
    final response = await _dio.get(_userPath);

    if (response.statusCode == HttpStatus.ok) {
      final responses = response.data;
      if (responses is List) {
        return responses.map((e) => user_model.fromJson(e)).toList();
      }
    }
  }
}
