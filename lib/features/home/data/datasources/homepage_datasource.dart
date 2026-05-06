import 'package:uit_buddy_mobile/features/home/data/models/homepage_model.dart';

abstract interface class HomepageDatasource {
  Future<HomePageModel> getHomePageData({
    required int page,
    required int limit,
    required String sortType,
    required String sortBy,
  });
}
