import 'package:uit_buddy_mobile/features/onboarding/data/datasources/firebase_remote_datasource.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDatasource _remoteDatasource;

  FirebaseRepositoryImpl(this._remoteDatasource);

  @override
  Future<bool> requestPermission() => _remoteDatasource.requestPermission();

  @override
  Future<String?> getFcmToken() => _remoteDatasource.getFcmToken();

  @override
  Stream<String?> onTokenRefresh() => _remoteDatasource.onTokenRefresh();
}
