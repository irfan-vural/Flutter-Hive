import 'dart:io';

import 'package:dio/dio.dart';

import '../model/user_model.dart';

abstract class IHomeService {
  late final Dio dio;
  IHomeService(this.dio);

  Future<List<UserModel>?> fetchUsers();
}

final _userPath = '/comments';

class HomeService extends IHomeService {
  HomeService(super.dio);

  @override
  Future<List<UserModel>?> fetchUsers() async {
    final response = await dio.get(_userPath);

    if (response.statusCode == HttpStatus.ok) {
      final responses = response.data;
      if (responses is List) {
        return responses.map((e) => UserModel.fromJson(e)).toList();
      }
    }
  }
}
