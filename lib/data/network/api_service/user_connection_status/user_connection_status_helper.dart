import '../../../../models/connection_model/user_connection_status_request_model.dart';
import '../../../../models/connection_model/user_connection_status_response_model.dart';
import '../../../../utils/api_utils/api_result/api_result.dart';

abstract class UserConnectionStatusHelper {
  Future<ApiResult<UserConnectionStatusResponseModel>> getUserConnectionStatus(UserConnectionStatusRequestModel userConnectionStatusModel,);
}
