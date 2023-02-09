import 'package:dio/dio.dart';

import '../date_util.dart';
import '../paging/pagingresult/paging_data_result.dart';
import '../response_wrapper.dart';

extension MainStructureResponseWrapperExt on Response<dynamic> {
  MainStructureResponseWrapper wrapResponse() {
    return MainStructureResponseWrapper.factory(data);
  }
}

extension DateTimeResponseWrapperExt on ResponseWrapper {
  DateTime? mapFromResponseToDateTime() {
    return response != null ? DateUtil.standardDateFormat.parse(response) : null;
  }
}

extension PagingResponseWrapperExt on ResponseWrapper {
  PagingDataResult<T> mapFromResponseToPagingDataResult<T>(List<T> Function(dynamic dataResponse) onMapToPagingDataResult) {
    dynamic pagingMeta = response["meta"];
    dynamic data = response["data"];
    return PagingDataResult<T>(
      page: pagingMeta["current_page"],
      totalPage: pagingMeta["last_page"],
      totalItem: pagingMeta["total"],
      itemList: onMapToPagingDataResult(data)
    );
  }
}