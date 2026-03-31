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

  // Completer for the initiateCall Future — resolved when the call is accepted
  final _acceptCompleter = Completer<domain.CallEntity>();
  final _rejectCompleter = Completer<void>();
  final _endCallCompleter = Completer<void>();

  // ─── CometChat (cometchat_sdk) ────────────────────────────────────────────

  @override
  Future<domain.CallEntity> initiateCall({
    required String receiverId,
    required bool isGroup,
  }) async {
    // Reset completers from any previous call attempt
    if (!_acceptCompleter.isCompleted) {
      _acceptCompleter.completeError(
        Exception('Previous call attempt not completed'),
      );
    }

    final freshAcceptCompleter = Completer<domain.CallEntity>();
    final freshRejectCompleter = Completer<void>();

    // Register a one-time listener to handle call acceptance / rejection / cancel
    void listener(cc.Call? call) {
      if (call == null) return;
      final status = call.callStatus ?? '';
      if (status == cc.CometChatCallStatus.ongoing ||
          status == cc.CometChatCallStatus.initiated) {
        if (!freshAcceptCompleter.isCompleted) {
          freshAcceptCompleter.complete(_mapToEntity(call));
        }
      } else if (status == cc.CometChatCallStatus.rejected ||
          status == cc.CometChatCallStatus.cancelled ||
          status == cc.CometChatCallStatus.busy) {
        if (!freshRejectCompleter.isCompleted) {
          freshRejectCompleter.complete();
        }
      }
    }

    const listenerId = '__call_initiate_listener__';
    cc.CometChat.addCallListener(listenerId, _OneShotCallListener(listener));

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
        // If immediately accepted (local test scenario)
        if (initiatedCall.callStatus == cc.CometChatCallStatus.ongoing) {
          if (!freshAcceptCompleter.isCompleted) {
            freshAcceptCompleter.complete(_mapToEntity(initiatedCall));
          }
        }
      },
      onError: (cc.CometChatException e) {
        debugPrint('[CallDatasource] initiateCall error: ${e.message}');
        if (!freshAcceptCompleter.isCompleted) {
          freshAcceptCompleter.completeError(e);
        }
        if (!freshRejectCompleter.isCompleted) {
          freshRejectCompleter.completeError(e);
        }
      },
    );

    // Return the call entity once it's accepted
    return freshAcceptCompleter.future;
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

/// A one-shot [cc.CallListener] that fires its callback once then removes itself.
class _OneShotCallListener with cc.CallListener {
  _OneShotCallListener(this._onEvent);

  final void Function(cc.Call?) _onEvent;

  @override
  void onIncomingCallReceived(cc.Call call) {
    _onEvent(call);
    cc.CometChat.removeCallListener('__call_initiate_listener__');
  }

  @override
  void onOutgoingCallAccepted(cc.Call call) {
    _onEvent(call);
    cc.CometChat.removeCallListener('__call_initiate_listener__');
  }

  @override
  void onOutgoingCallRejected(cc.Call call) {
    _onEvent(call);
    cc.CometChat.removeCallListener('__call_initiate_listener__');
  }

  @override
  void onIncomingCallCancelled(cc.Call call) {
    _onEvent(call);
    cc.CometChat.removeCallListener('__call_initiate_listener__');
  }

  @override
  void onCallEndedMessageReceived(cc.Call call) {
    _onEvent(call);
  }
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
