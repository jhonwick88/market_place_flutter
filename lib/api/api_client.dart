import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

@RestApi(baseUrl: "http://demo.wifipayment.xyz/api")
abstract class ApiClient{
  factory ApiClient(Dio dio){
    dio.options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    return _ApiClient(dio, baseUrl: baseUrl);
  }


}

