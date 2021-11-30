import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:market_place_flutter/api/logging_interceptor.dart';
import 'package:market_place_flutter/models/base_model.dart';
import 'package:market_place_flutter/models/note.dart';
import 'package:market_place_flutter/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';

//@RestApi(baseUrl: "http://10.0.2.2:8000/api")
//@RestApi(baseUrl: "http://demo.wifipayment.xyz/api")
@RestApi(baseUrl: "http://derin.my.id/api")
abstract class ApiClient {
  factory ApiClient(BuildContext context) {
    Dio dio = Dio();
    dio.options = BaseOptions(
        contentType: "application/json",
        receiveTimeout: 10000,
        connectTimeout: 10000);
    dio.interceptors.add(AppInterceptors(context: context));
    dio.interceptors.add(LoggingInterceptor());
    return _ApiClient(dio);
  }

  @POST("/login")
  Future<BaseModel> postUserLogin(
      @Query("email") String email, @Query("password") String password);

  @POST("/logout")
  Future<BaseModel> postUserLogout();

  @GET("/payment/index")
  Future<BaseModel> getPaymentList(@Queries() Map<String, dynamic> queries);

  @GET("/payment-method/index")
  Future<BaseModel> getPaymentMethodList();

  @GET("/note/index")
  Future<BaseModel> getNoteList();

  @POST("/note/store")
  Future<BaseModel> postNote(@Queries() Map<String, dynamic> queries);

  @DELETE("/note/destroy/{id}")
  Future<BaseModel> destroyNote(@Path("id") int id);

  @PUT("/note/update/{id}")
  Future<BaseModel> updateNote(@Path("id") int id, @Body() Note note);

  @POST("/payment/store")
  Future<BaseModel> postPayment(@Queries() Map<String, dynamic> queries);
}

class AppInterceptors extends Interceptor {
  BuildContext context;

  AppInterceptors({required this.context});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    if (token != "") {
      print("token inter " + token);
      options.headers["Authorization"] = "Bearer " + token;
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("koneksi error ");
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
    if (err.response != null) {
      switch (err.type) {
        case DioErrorType.cancel:
          err..error = "Koneksi cancel";
          print("koneksi error 1");
          break;
        case DioErrorType.connectTimeout:
          err..error = "Koneksi connectTimeout";
          print("koneksi error 2");
          break;
        case DioErrorType.sendTimeout:
          err..error = "Koneksi sendTimeout";
          print("koneksi error 3");
          break;
        case DioErrorType.receiveTimeout:
          err..error = "Koneksi receiveTimeout";
          print("koneksi error 4");
          break;
        case DioErrorType.response:
          err..error = "Koneksi response";
          print("koneksi error 5");
          break;
        case DioErrorType.other:
          err..error = "Koneksi other";
          print("koneksi error 6");
      }
    } else {
      handler.next(err);
    }
    //super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data['code'] == -3) {
      // Navigator.push(context,
      //     new MaterialPageRoute(builder: (context) => new LoginPage()));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      // Navigator.of(context)
      // .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
    print("onResponse IZHU---------" + response.data['code'].toString());

    //if(response.statusCode == 200)
    super.onResponse(response, handler);
  }
}
