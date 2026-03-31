import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/call_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/call_repository.dart';

class CallRepositoryImpl implements CallRepository {
  CallRepositoryImpl({required CallDatasourceInterface datasource})
    : _datasource = datasource;

  final CallDatasourceInterface _datasource;

  @override
  Future<Either<Failure, CallEntity>> initiateCall({
    required String receiverId,
    required bool isGroup,
  }) async {
    try {
      final call = await _datasource.initiateCall(
        receiverId: receiverId,
        isGroup: isGroup,
      );
      return Right(call);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CallEntity>> acceptCall(String sessionId) async {
    try {
      final call = await _datasource.acceptCall(sessionId);
      return Right(call);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectCall(
    String sessionId, {
    bool busy = false,
  }) async {
    try {
      await _datasource.rejectCall(sessionId, busy: busy);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> endCall(String sessionId) async {
    try {
      await _datasource.endCall(sessionId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  void clearActiveCall() {
    _datasource.clearActiveCall();
  }

  @override
  Future<String> getUserAuthToken() {
    return _datasource.getUserAuthToken();
  }
}
