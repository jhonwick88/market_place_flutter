import 'package:dio/dio.dart';

class BaseModel<T>{
  late CodeMessage _codeMessage;
  late T data;

  setData(T data){
    this.data = data;
  }
  setException(CodeMessage codeMessage){
    _codeMessage = _codeMessage;
  }
  get getException{
    return _codeMessage;
  }
}

class CodeMessage implements Exception{
  int _code = 0;
  String _message = "";

  CodeMessage.withError(DioError error){
    _handle(error);
  }

  _handle(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        _message = "Request was cancelled";
        break;
      case DioErrorType.connectTimeout:
        _message = "Connection timeout";
        break;
      case DioErrorType.other:
        _message =
        "Connection failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        _message = "Receive timeout in connection";
        break;
      case DioErrorType.response:
        _message =
        "Received invalid status code: ${error.response!.statusCode}";
        break;
      case DioErrorType.sendTimeout:
        _message = "Receive timeout in send request";
        break;
    }
    return _message;
  }
}