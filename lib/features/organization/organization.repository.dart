import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mvp_proex/app/app.repository.dart';
import 'package:mvp_proex/features/organization/organization.model.dart';

class OrganizationRepository extends AppRepository {
  Dio dio = new Dio();

  Future<String> createorganization(
      OrganizationModel organizationModel, String token) async {
    try {
      return await dio
          .post(AppRepository.path + AppRepository.queryOrganization,
              data: organizationModel.toJson(),
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }))
          .then(
        (value) {
          return value.toString();
        },
      );
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          return "API Offline";
        }
        return e.response!.statusCode.toString();
      }
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getall(String token) async {
    try {
      return await dio
          .get(AppRepository.path + "/organizations",
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }))
          .then(
        (value) {
          log(value.data.toString());
          return value.toString();
        },
      );
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          return "API Offline";
        }
        return e.response!.statusCode.toString();
      }
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
