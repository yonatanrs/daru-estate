import '../../../misc/paging/pagingresult/paging_data_result.dart';
import 'house.dart';

class GetHouseListResponse {
  PagingDataResult<House> housePagingDataResult;

  GetHouseListResponse({
    required this.housePagingDataResult
  });
}