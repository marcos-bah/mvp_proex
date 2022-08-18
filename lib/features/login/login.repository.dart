import 'package:dio/dio.dart';
import 'package:mvp_proex/app/app.repository.dart';

class LoginRepository extends AppRepository {
  // @override
  // final Dio dio = Dio();

  Future<String> postToken(
      {required dynamic model, required String query}) async {
    const String erroMessage = "Erro na consulta";
    try {
      return await dio
          .post(
        AppRepository.path + AppRepository.queryLogin,
        data: model.toJson(),
      )
          .then(
        (res) {
          return res.data['token'] ?? erroMessage;
        },
      );
    } catch (e) {
      return erroMessage;
    }
  }
}
