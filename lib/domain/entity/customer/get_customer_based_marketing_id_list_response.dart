import '../../../misc/paging/pagingresult/paging_data_result.dart';
import 'customer.dart';

class GetCustomerBasedMarketingIdPagingResponse {
  PagingDataResult<Customer> customerPagingDataResult;

  GetCustomerBasedMarketingIdPagingResponse({
    required this.customerPagingDataResult
  });
}