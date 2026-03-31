import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';

abstract interface class CallRepository {
  /// Initiate an outgoing audio call to [receiverId].
  Future<Either<Failure, CallEntity>> initiateCall({
    required String receiverId,
    required bool isGroup,
  });

  /// Accept an incoming call identified by [sessionId].
  Future<Either<Failure, CallEntity>> acceptCall(String sessionId);

  /// Reject an incoming call. Set [busy] to true to send BUSY status.
  Future<Either<Failure, void>> rejectCall(
    String sessionId, {
    bool busy = false,
  });

  /// End an active call.
  Future<Either<Failure, void>> endCall(String sessionId);

  /// Clear the active call from local state.
  void clearActiveCall();

  /// Get the user's CometChat auth token (needed for call token generation).
  Future<String> getUserAuthToken();
}
