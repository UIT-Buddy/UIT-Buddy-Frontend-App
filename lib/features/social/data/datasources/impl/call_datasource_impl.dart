import 'dart:async';

import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart' as ccc;
import 'package:cometchat_sdk/cometchat_sdk.dart' as cc;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Widget;
import 'package:uit_buddy_mobile/features/social/data/datasources/call_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart'
    as domain;

class CallDatasourceImpl implements CallDatasourceInterface {
  CallDatasourceImpl() {
    // Register persistent listener for incoming calls (CometChat real-time)
    cc.CometChat.addCallListener(_incomingListenerId, _incomingListener);
  }

  // ─── Incoming Call Listener ───────────────────────────────────────────────

  static const _incomingListenerId = '__call_incoming_listener__';

  final _incomingCallController =
      StreamController<domain.CallEntity>.broadcast();
  Stream<domain.CallEntity> get incomingCallStream =>
      _incomingCallController.stream;

  late final _incomingListener = _IncomingCallListener(
    onIncoming: (call) {
      if (!_incomingCallController.isClosed) {
        _incomingCallController.add(_mapToEntity(call));
      }
    },
  );

  // ─── Session Events Stream ────────────────────────────────────────────────

  final _sessionEventController =
      StreamController<CallSessionEvent>.broadcast();
  Stream<CallSessionEvent> get sessionEvents => _sessionEventController.stream;

  final _rejectCompleter = Completer<void>();
  final _endCallCompleter = Completer<void>();

  /// The sessionId returned by the native CometChat SDK on call initiation.
  /// This is captured from the native callback result, not from the Dart Call object
  /// (which has a null sessionId in this SDK version).
  String _pendingSessionId = '';
  @override
  String get pendingSessionId => _pendingSessionId;

  // ─── CometChat (cometchat_sdk) ────────────────────────────────────────────

  @override
  Future<domain.CallEntity> initiateCall({
    required String receiverId,
    required bool isGroup,
  }) async {
    final completer = Completer<domain.CallEntity>();
    const listenerId = '__call_initiate_listener__';

    // Register a persistent listener to watch for call acceptance / rejection
    final listener = _OutgoingCallListener(
      onOutgoingAccepted: (call) {
        // Capture sessionId from the accepted call (may differ from initiation sessionId)
        if (call.sessionId != null && call.sessionId!.isNotEmpty) {
          _pendingSessionId = call.sessionId!;
        }
        if (!completer.isCompleted) {
          completer.complete(_mapToEntity(call));
        }
        cc.CometChat.removeCallListener(listenerId);
      },
      onOutgoingRejected: (call) {
        if (!completer.isCompleted) {
          completer.completeError(Exception('Call was rejected'));
        }
        cc.CometChat.removeCallListener(listenerId);
      },
      onIncomingCancelled: (call) {
        if (!completer.isCompleted) {
          completer.completeError(Exception('Call was cancelled'));
        }
        cc.CometChat.removeCallListener(listenerId);
      },
    );
    cc.CometChat.addCallListener(listenerId, listener);

    final call = cc.Call(
      receiverUid: receiverId,
      receiverType: isGroup
          ? cc.CometChatConversationType.group
          : cc.CometChatConversationType.user,
      type: cc.CometChatCallType.audio,
    );

    cc.CometChat.initiateCall(
      call,
      onSuccess: (cc.Call initiatedCall) {
        debugPrint(
          '[CallDatasource] initiateCall success: ${initiatedCall.sessionId}',
        );
        // Capture the sessionId from the Call object returned by the native SDK.
        // This is the value needed to cancel the call later.
        // Also capture it from the listener's accepted callback as a backup.
        if (initiatedCall.sessionId != null &&
            initiatedCall.sessionId!.isNotEmpty) {
          _pendingSessionId = initiatedCall.sessionId!;
        }
        // If already in "ongoing" state (immediate acceptance), complete now
        if (initiatedCall.callStatus == cc.CometChatCallStatus.ongoing) {
          if (!completer.isCompleted) {
            completer.complete(_mapToEntity(initiatedCall));
          }
          cc.CometChat.removeCallListener(listenerId);
        }
        // Otherwise the listener will handle onOutgoingAccepted when it arrives
      },
      onError: (cc.CometChatException e) {
        debugPrint('[CallDatasource] initiateCall error: ${e.message}');
        // ERROR_CALL_IN_PROGRESS means a call is already active — don't
        // complete with error; the listener will handle it when the existing
        // call ends and a new one is accepted.
        if (e.code != 'ERROR_CALL_IN_PROGRESS') {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
          cc.CometChat.removeCallListener(listenerId);
        }
      },
    );

    return completer.future;
  }

  @override
  Future<domain.CallEntity> acceptCall(String sessionId) async {
    final completer = Completer<domain.CallEntity>();

    cc.CometChat.acceptCall(
      sessionId,
      onSuccess: (cc.Call acceptedCall) {
        debugPrint(
          '[CallDatasource] acceptCall success: ${acceptedCall.sessionId}',
        );
        completer.complete(_mapToEntity(acceptedCall));
      },
      onError: (cc.CometChatException e) {
        debugPrint('[CallDatasource] acceptCall error: ${e.message}');
        completer.completeError(e);
      },
    );

    return completer.future;
  }

  @override
  Future<void> rejectCall(String sessionId, {bool busy = false}) async {
    if (_rejectCompleter.isCompleted) return;

    final status = busy
        ? cc.CometChatCallStatus.busy
        : cc.CometChatCallStatus.rejected;

    cc.CometChat.rejectCall(
      sessionId,
      status,
      onSuccess: (cc.Call rejectedCall) {
        debugPrint(
          '[CallDatasource] rejectCall success: ${rejectedCall.sessionId}',
        );
        _rejectCompleter.complete();
      },
      onError: (cc.CometChatException e) {
        debugPrint('[CallDatasource] rejectCall error: ${e.message}');
        _rejectCompleter.completeError(e);
      },
    );

    return _rejectCompleter.future;
  }

  @override
  Future<void> endCall(String sessionId) async {
    if (_endCallCompleter.isCompleted) return;

    cc.CometChat.endCall(
      sessionId,
      onSuccess: (cc.Call endedCall) {
        debugPrint('[CallDatasource] endCall success');
        _endCallCompleter.complete();
      },
      onError: (cc.CometChatException e) {
        debugPrint('[CallDatasource] endCall error: ${e.message}');
        _endCallCompleter.completeError(e);
      },
    );

    return _endCallCompleter.future;
  }

  @override
  Future<void> cancelOutgoingCall() async {
    // Cancel the most recent pending outgoing call
    // Use the sessionId captured from the native CometChat SDK response
    final sessionId = _pendingSessionId;
    if (sessionId.isEmpty) return;

    final completer = Completer<void>();

    cc.CometChat.rejectCall(
      sessionId,
      cc.CometChatCallStatus.cancelled,
      onSuccess: (cc.Call call) {
        debugPrint('[CallDatasource] cancelOutgoingCall success');
        _pendingSessionId = '';
        completer.complete();
      },
      onError: (cc.CometChatException e) {
        debugPrint('[CallDatasource] cancelOutgoingCall error: ${e.message}');
        // Even if it fails, clear pendingSessionId so next call can proceed
        _pendingSessionId = '';
        completer.complete();
      },
    );

    return completer.future;
  }

  @override
  void clearActiveCall() {
    cc.CometChat.clearActiveCall();
  }

  @override
  Future<String> getUserAuthToken() async {
    return (await cc.CometChat.getUserAuthToken()) ?? '';
  }

  // ─── CometChatCalls (cometchat_calls_sdk) ─────────────────────────────────

  @override
  Future<ccc.GenerateToken> generateCallToken({
    required String sessionId,
    required String authToken,
  }) async {
    final completer = Completer<ccc.GenerateToken>();

    ccc.CometChatCalls.generateToken(
      sessionId,
      authToken,
      onSuccess: (ccc.GenerateToken generateToken) {
        debugPrint('[CallDatasource] generateToken success');
        completer.complete(generateToken);
      },
      onError: (ccc.CometChatCallsException e) {
        debugPrint('[CallDatasource] generateToken error: ${e.message}');
        completer.completeError(e);
      },
    );

    return completer.future;
  }

  @override
  void startCallSession({
    required ccc.GenerateToken token,
    required ccc.CallSettings callSettings,
  }) {
    ccc.CometChatCalls.startSession(
      token.token!,
      callSettings,
      onSuccess: (Widget? callingWidget) {
        debugPrint(
          '[CallDatasource] startSession success, widget: $callingWidget',
        );
        _sessionEventController.add(CallSessionStartedEvent(callingWidget));
      },
      onError: (ccc.CometChatCallsException e) {
        debugPrint('[CallDatasource] startSession error: ${e.message}');
        _sessionEventController.add(
          CallSessionErrorEvent(e.message ?? 'Session error'),
        );
      },
    );
  }

  @override
  Future<void> endCallSession() async {
    final completer = Completer<void>();

    ccc.CometChatCalls.endSession(
      onSuccess: (String success) {
        debugPrint('[CallDatasource] endSession success');
        completer.complete();
      },
      onError: (ccc.CometChatCallsException e) {
        debugPrint('[CallDatasource] endSession error: ${e.message}');
        completer.completeError(e);
      },
    );

    return completer.future;
  }

  @override
  void addCallsEventListener(
    String listenerId,
    ccc.CometChatCallsEventsListener listener,
  ) {
    ccc.CometChatCalls.addCallsEventListeners(listenerId, listener);
  }

  @override
  void removeCallsEventListener(String listenerId) {
    ccc.CometChatCalls.removeCallsEventListeners(listenerId);
  }

  // ─── Mapping ───────────────────────────────────────────────────────────────

  domain.CallEntity _mapToEntity(cc.Call call) {
    return domain.CallEntity(
      sessionId: call.sessionId ?? '',
      callStatus: _mapCallStatus(call.callStatus),
      callType: call.type == cc.CometChatCallType.video
          ? domain.CallType.video
          : domain.CallType.audio,
      receiverId: call.receiverUid,
      receiverName: _getName(call.callReceiver),
      receiverAvatar: _getAvatar(call.callReceiver),
      senderId: _getSenderUid(call.callInitiator) ?? '',
      senderName: _getName(call.callInitiator),
      senderAvatar: _getAvatar(call.callInitiator),
      initiatedAt: call.initiatedAt,
    );
  }

  domain.CallStatus _mapCallStatus(String? status) {
    switch (status) {
      case cc.CometChatCallStatus.initiated:
        return domain.CallStatus.initiated;
      case cc.CometChatCallStatus.ongoing:
        return domain.CallStatus.ongoing;
      case cc.CometChatCallStatus.rejected:
        return domain.CallStatus.rejected;
      case cc.CometChatCallStatus.ended:
        return domain.CallStatus.ended;
      case cc.CometChatCallStatus.cancelled:
        return domain.CallStatus.cancelled;
      case cc.CometChatCallStatus.busy:
        return domain.CallStatus.busy;
      case cc.CometChatCallStatus.unanswered:
        return domain.CallStatus.unanswered;
      default:
        return domain.CallStatus.initiated;
    }
  }

  String _getName(cc.AppEntity? entity) {
    if (entity is cc.User) return entity.name;
    if (entity is cc.Group) return entity.name;
    return '';
  }

  String? _getAvatar(cc.AppEntity? entity) {
    if (entity is cc.User) return entity.avatar;
    if (entity is cc.Group) return entity.icon;
    return null;
  }

  String? _getSenderUid(cc.AppEntity? entity) {
    if (entity is cc.User) return entity.uid;
    if (entity is cc.Group) return entity.guid;
    return null;
  }

  /// Clean up stream controllers and listeners. Call this when disposing.
  void dispose() {
    _incomingCallController.close();
    _sessionEventController.close();
    cc.CometChat.removeCallListener(_incomingListenerId);
  }
}

/// Persistent [cc.CallListener] that forwards incoming calls to the stream.
class _IncomingCallListener with cc.CallListener {
  _IncomingCallListener({required this.onIncoming});

  final void Function(cc.Call) onIncoming;

  @override
  void onIncomingCallReceived(cc.Call call) {
    onIncoming(call);
  }

  @override
  void onOutgoingCallAccepted(cc.Call call) {}

  @override
  void onOutgoingCallRejected(cc.Call call) {}

  @override
  void onIncomingCallCancelled(cc.Call call) {}

  @override
  void onCallEndedMessageReceived(cc.Call call) {}
}

/// Listens for outgoing call events and resolves the [Completer].
class _OutgoingCallListener with cc.CallListener {
  _OutgoingCallListener({
    required this.onOutgoingAccepted,
    required this.onOutgoingRejected,
    required this.onIncomingCancelled,
  });

  final void Function(cc.Call) onOutgoingAccepted;
  final void Function(cc.Call) onOutgoingRejected;
  final void Function(cc.Call) onIncomingCancelled;

  @override
  void onIncomingCallReceived(cc.Call call) {}

  @override
  void onOutgoingCallAccepted(cc.Call call) {
    onOutgoingAccepted(call);
  }

  @override
  void onOutgoingCallRejected(cc.Call call) {
    onOutgoingRejected(call);
  }

  @override
  void onIncomingCallCancelled(cc.Call call) {
    onIncomingCancelled(call);
  }

  @override
  void onCallEndedMessageReceived(cc.Call call) {}
}

/// Internal session events emitted via [CallDatasourceImpl.sessionEvents].
sealed class CallSessionEvent {
  CallSessionEvent();

  factory CallSessionEvent.started(Widget? callingWidget) =
      CallSessionStartedEvent;
  factory CallSessionEvent.ended() = CallSessionEndedEvent;
  factory CallSessionEvent.endButtonPressed() = CallSessionEndButtonEvent;
  factory CallSessionEvent.userJoined(ccc.RTCUser user) =
      CallSessionUserJoinedEvent;
  factory CallSessionEvent.userLeft(ccc.RTCUser user) =
      CallSessionUserLeftEvent;
  factory CallSessionEvent.timeout() = CallSessionTimeoutEvent;
  factory CallSessionEvent.error(String message) = CallSessionErrorEvent;
}

final class CallSessionStartedEvent extends CallSessionEvent {
  final Widget? callingWidget;
  CallSessionStartedEvent(this.callingWidget);
}

final class CallSessionEndedEvent extends CallSessionEvent {}

final class CallSessionEndButtonEvent extends CallSessionEvent {}

final class CallSessionUserJoinedEvent extends CallSessionEvent {
  final ccc.RTCUser user;
  CallSessionUserJoinedEvent(this.user);
}

final class CallSessionUserLeftEvent extends CallSessionEvent {
  final ccc.RTCUser user;
  CallSessionUserLeftEvent(this.user);
}

final class CallSessionTimeoutEvent extends CallSessionEvent {}

final class CallSessionErrorEvent extends CallSessionEvent {
  final String message;
  CallSessionErrorEvent(this.message);
}
