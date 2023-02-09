import 'package:dio/dio.dart';

import '../constant.dart';
import '../error/cart_empty_error.dart';
import '../error/message_error.dart';
import '../error/not_found_error.dart';
import '../error/validation_error.dart';
import 'error_provider.dart';

class DefaultErrorProvider extends ErrorProvider {
  @override
  ErrorProviderResult? onGetErrorProviderResult(e) {
    if (e is DioError) {
      return _handlingDioError(e);
    } else if (e is NotFoundError) {
      return ErrorProviderResult(
        title: "Not Found",
        message: e.message
      );
    } else if (e is ValidationError) {
      return ErrorProviderResult(
        title: e.message,
        message: e.message
      );
    } else if (e is MessageError) {
      return ErrorProviderResult(
        title: e.title,
        message: e.message
      );
    } else if (e is CartEmptyError){
      return ErrorProviderResult(
        title: "Cart Is Empty",
        message: "Now cart is empty."
      );
    } else {
      return ErrorProviderResult(
        title: "Something Failed",
        message: e.toString()
      );
    }
  }

  ErrorProviderResult _handlingDioError(DioError e) {
    DioErrorType dioErrorType = e.type;
    if (dioErrorType == DioErrorType.other) {
      return ErrorProviderResult(
        title: "Internet Connection Problem",
        message: "There is a problem in internet connection.",
        imageAssetUrl: Constant.imageNoInternet
      );
    } else if (dioErrorType == DioErrorType.connectTimeout) {
      return ErrorProviderResult(
        title: "Internet Connection Timeout",
        message: "The connection of internet has been timeout.",
        imageAssetUrl: Constant.imageNoInternet
      );
    } else if (dioErrorType == DioErrorType.sendTimeout) {
      return ErrorProviderResult(
        title: "Internet Connection Send Timeout",
        message: "The connection of internet has been timeout while sending.",
        imageAssetUrl: Constant.imageNoInternet
      );
    } else if (dioErrorType == DioErrorType.receiveTimeout) {
      return ErrorProviderResult(
        title: "Internet Connection Receive Timeout",
        message: "The connection of internet has been timeout while receiving.",
        imageAssetUrl: Constant.imageNoInternet
      );
    } else if (dioErrorType == DioErrorType.cancel) {
      return ErrorProviderResult(
        title: "Request Canceled",
        message: "Request has been canceled.",
        imageAssetUrl: Constant.imageFailed
      );
    } else if (dioErrorType == DioErrorType.response) {
      dynamic response = e.response?.data;
      return ErrorProviderResult(
        title: "Request Failed",
        message: (response is Map ? response['message'] : (response is String ? response.substring(0, response.length > 500 ? 500 : response.length) : response)) ?? "(No Message)",
        imageAssetUrl: Constant.imageFailed
      );
    } else {
      return ErrorProviderResult(
        title: "Something Wrong",
        message: "Something wrong related with internet connection.",
        imageAssetUrl: Constant.imageFailed
      );
    }
  }
}