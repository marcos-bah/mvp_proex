import 'package:dio/dio.dart';
import 'package:mvp_proex/app/app.repository.dart';

class PointRepository extends AppRepository {
  Future<String> getAllPoints(String token) async {
    const String erroMessage = "Erro na consulta";
    try {
      print("Get all points...");
      return await dio
          .get(
        AppRepository.path + AppRepository.queryPoints,
        options: Options(headers: {'Authorization': "Bearer $token"}),
      )
          .then(
        (res) {
          print(res.data.toString());
          return res.toString();
        },
      );
    } catch (e) {
      return erroMessage;
    }
  }
}
