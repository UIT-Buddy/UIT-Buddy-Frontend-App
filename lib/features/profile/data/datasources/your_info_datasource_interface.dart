import 'package:uit_buddy_mobile/core/network/api/api_response.dart';
import 'package:uit_buddy_mobile/features/profile/data/models/your_info_model.dart';

abstract interface class YourInfoDatasourceInterface {
  Future<ApiResponse<YourInfoModel>> getYourInfo();
  Future<ApiResponse<YourInfoModel>> updateYourInfo({
    required YourInfoModel info,
  });
}
