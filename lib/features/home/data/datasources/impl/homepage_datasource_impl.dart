import 'package:dio/dio.dart';
import 'package:uit_buddy_mobile/features/home/data/datasources/homepage_datasource.dart';
import 'package:uit_buddy_mobile/features/home/data/models/homepage_model.dart';

class HomePageDatasourceImpl implements HomepageDatasource {
  HomePageDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<HomePageModel> getHomePageData({
    required int page,
    required int limit,
    required String sortType,
    required String sortBy,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/home',
      queryParameters: {
        'page': page,
        'limit': limit,
        'sortType': sortType,
        'sortBy': sortBy,
      },
    );
    return HomePageModel.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }
}
