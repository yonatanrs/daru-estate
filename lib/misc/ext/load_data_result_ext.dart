import '../error/load_data_result_error.dart';
import '../load_data_result.dart';

typedef MapLoadDataResultType<O, T> = O Function(T);

extension LoadDataResultExt<T> on LoadDataResult<T> {
  bool get isSuccess => this is SuccessLoadDataResult<T>;
  bool get isFailed => this is FailedLoadDataResult<T>;
  bool get isLoading => this is IsLoadingLoadDataResult<T>;
  bool get isNotLoading => this is NoLoadDataResult<T>;
  T? get resultIfSuccess => isSuccess ? (this as SuccessLoadDataResult<T>).value : null;
  dynamic get resultIfFailed => isFailed ? (this as FailedLoadDataResult<T>).e : null;

  LoadDataResult<O> map<O>(MapLoadDataResultType<O, T> onMap) {
    if (this is SuccessLoadDataResult<T>) {
      T value = (this as SuccessLoadDataResult<T>).value;
      return SuccessLoadDataResult<O>(value: onMap(value));
    } else if (this is FailedLoadDataResult<T>) {
      FailedLoadDataResult<T> failedLoadDataResult = this as FailedLoadDataResult<T>;
      return FailedLoadDataResult<O>(e: failedLoadDataResult.e, stackTrace: failedLoadDataResult.stackTrace);
    } else {
      try {
        throw LoadDataResultError(message: "Load data result is not suitable.");
      } catch (e, stackTrace) {
        return FailedLoadDataResult<O>(e: e, stackTrace: stackTrace);
      }
    }
  }
}