class ResponseWrapper {
  final dynamic response;

  ResponseWrapper(this.response);
}

abstract class _FullResponseWrapper extends ResponseWrapper {
  @override
  dynamic get response => _fullResponse;

  late final dynamic _fullResponse;

  _FullResponseWrapper(dynamic fullResponse) : super(fullResponse) {
    _fullResponse = fullResponse;
  }
}

class MainStructureResponseWrapper extends _FullResponseWrapper {
  factory MainStructureResponseWrapper.factory(dynamic fullResponse) {
    return MainStructureResponseWrapper(fullResponse);
  }

  MainStructureResponseWrapper(dynamic fullResponse) : super(fullResponse);
}