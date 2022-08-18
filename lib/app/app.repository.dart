import 'dart:convert';

import 'package:dio/dio.dart';

class AppRepository {
  static const String path = 'https://app-proex.herokuapp.com';
  static const String queryLogin = '/login';
  static const String queryUser = '/users';
  static const String queryMap = '/maps';
  static const String queryBuilder = '/api/accounts';
  static const String queryOrganization = '/api/accounts';
  static const String queryPoints = '/points';

  Dio dio = Dio();

  Future<String> post(
      {required dynamic model, required String query, Options? options}) async {
    const String erroMessage = "Erro na consulta";
    print(model.toJson());
    try {
      return await dio
          .post(
        AppRepository.path + query,
        data: model.toJson(),
        options: options,
      )
          .then(
        (res) {
          return res.data.toString();
        },
      );
    } catch (e) {
      print(e);
      return erroMessage;
    }
  }

  Future<String> get(
      {required String id, required String query, Options? options}) async {
    const String erroMessage = "Erro na consulta";
    print(AppRepository.path + query + '/' + id);
    try {
      return await dio
          .get(
        AppRepository.path + query + '/' + id,
        options: options,
      )
          .then(
        (res) {
          return res.data["id"] == null
              ? res.data.toString()
              : jsonEncode(res.data);
        },
      );
    } catch (e) {
      print(e);
      return erroMessage;
    }
  }
}
