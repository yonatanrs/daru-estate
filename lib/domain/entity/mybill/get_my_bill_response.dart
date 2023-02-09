import '../../../misc/paging/pagingresult/paging_data_result.dart';
import 'bill.dart';

class GetMyBillResponse {
  PagingDataResult<Bill> billPagingDataResult;

  GetMyBillResponse({
    required this.billPagingDataResult
  });
}