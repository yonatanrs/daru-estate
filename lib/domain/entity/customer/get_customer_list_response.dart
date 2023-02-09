import '../../../misc/paging/pagingresult/paging_data_result.dart';
import 'customer.dart';

class GetCustomerPagingResponse {
  PagingDataResult<Customer> customerPagingDataResult;

  GetCustomerPagingResponse({
    required this.customerPagingDataResult
  });
}