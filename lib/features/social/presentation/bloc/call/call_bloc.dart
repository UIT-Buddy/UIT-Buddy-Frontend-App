import 'dart:async';

import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart' as ccc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/impl/call_datasource_impl.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/accept_call_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/end_call_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/get_call_auth_token_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/initiate_call_usecase.dart';
import 'package:uit_buddy_mobile/features/social/domain/usecases/reject_call_usecase.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_event.dart';
import 'package:uit_buddy_mobile/features/social/presentation/bloc/call/call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc({
    required InitiateCallUsecase initiateCallUsecase,
    required AcceptCallUsecase acceptCallUsecase,
    required RejectCallUsecase rejectCallUsecase,
    required EndCallUsecase endCallUsecase,
    required GetCallAuthTokenUsecase getCallAuthTokenUsecase,
    required CallDatasourceImpl callDatasource,
  }) : _initiateCallUsecase = initiateCallUsecase,
       _acceptCallUsecase = acceptCallUsecase,
       _rejectCallUsecase = rejectCallUsecase,
       _endCallUsecase = endCallUsecase,
       _getCallAuthTokenUsecase = getCallAuthTokenUsecase,
       _callDatasource = callDatasource,
       super(const CallState.idle()) {
    on<CallInitiate>(_onInitiate);
    on<CallIncomingReceived>(_onIncomingReceived);
    on<CallAccept>(_onAccept);
    on<CallReject>(_onReject);
    on<CallEnd>(_onEnd);
    on<CallEndButtonPressed>(_onEndButtonPressed);
    on<CallSessionTimeout>(_onSessionTimeout);
    on<CallParticipantJoined>(_onParticipantJoined);
    on<CallParticipantLeft>(_onParticipantLeft);
    on<CallSessionStarted>(_onSessionStarted);
    on<CallDismissEnded>(_onDismissEnded);

    // Register the Calls SDK event listener
    _callDatasource.addCallsEventListener(_listenerId, _callsListener);

    // Forward session events from the datasource to the bloc
    _sessionSubscription = _callDatasource.sessionEvents.listen((event) {
      if (event is CallSessionEndButtonEvent) {
        add(const CallEndButtonPressed());
      } else if (event is CallSessionUserJoinedEvent) {
        add(
          CallParticipantJoined(
            uid: event.user.uid ?? '',
            name: event.user.name ?? '',
          ),
        );
      } else if (event is CallSessionUserLeftEvent) {
        add(
          CallParticipantLeft(
            uid: event.user.uid ?? '',
            name: event.user.name ?? '',
          ),
        );
      } else if (event is CallSessionTimeoutEvent) {
        add(const CallSessionTimeout());
      }
    });

    // Forward incoming calls from the persistent listener
    _incomingSubscription = _callDatasource.incomingCallStream.listen((call) {
      add(CallIncomingReceived(call));
    });
  }

  // ─── Dependencies ──────────────────────────────────────────────────────────

  final InitiateCallUsecase _initiateCallUsecase;
  final AcceptCallUsecase _acceptCallUsecase;
  final RejectCallUsecase _rejectCallUsecase;
  final EndCallUsecase _endCallUsecase;
  final GetCallAuthTokenUsecase _getCallAuthTokenUsecase;
  final CallDatasourceImpl _callDatasource;

  static const _listenerId = '__call_bloc_listener__';

  StreamSubscription<CallSessionEvent>? _sessionSubscription;
  StreamSubscription<CallEntity>? _incomingSubscription;

  Future<void> _onIncomingReceived(
    CallIncomingReceived event,
    Emitter<CallState> emit,
  ) async {
    // Only show incoming UI if idle (not already in a call)
    if (state is CallIdle) {
      emit(CallState.incoming(incomingCall: event.call));
    }
  }

  // ─── Event Handlers ────────────────────────────────────────────────────────

  Future<void> _onInitiate(CallInitiate event, Emitter<CallState> emit) async {
    emit(
      CallState.outgoing(
        receiverId: event.receiverId,
        receiverName: event.receiverName,
      ),
    );

    final result = await _initiateCallUsecase(
      InitiateCallParams(receiverId: event.receiverId, isGroup: event.isGroup),
    );

    await result.fold(
      (failure) async {
        emit(CallState.error(message: failure.message));
        await Future.delayed(const Duration(seconds: 2));
        emit(const CallState.idle());
      },
      (call) async {
        // Call was accepted — transition to connecting
        emit(
          CallState.connecting(
            receiverId: event.receiverId,
            receiverName: event.receiverName,
          ),
        );
        await _startSession(call);
      },
    );
  }

  Future<void> _onAccept(CallAccept event, Emitter<CallState> emit) async {
    final current = state;
    if (current is! CallIncoming) return;

    final call = current.incomingCall;
    emit(
      CallState.connecting(
        receiverId: call.receiverId,
        receiverName: call.receiverName,
      ),
    );

    final result = await _acceptCallUsecase(
      AcceptCallParams(sessionId: call.sessionId),
    );

    await result.fold(
      (failure) async {
        emit(CallState.error(message: failure.message));
        await Future.delayed(const Duration(seconds: 2));
        emit(const CallState.idle());
      },
      (acceptedCall) async {
        await _startSession(acceptedCall);
      },
    );
  }

  Future<void> _onReject(CallReject event, Emitter<CallState> emit) async {
    final current = state;
    if (current is! CallIncoming) return;

    final sessionId = current.incomingCall.sessionId;
    await _rejectCallUsecase(
      RejectCallParams(sessionId: sessionId, busy: event.busy),
    );

    emit(const CallState.idle());
  }

  Future<void> _onEnd(CallEnd event, Emitter<CallState> emit) async {
    final current = state;
    String? sessionId;

    if (current is CallOutgoing) {
      // Cancel the outgoing call by rejecting it
      sessionId = null; // No session yet
    } else if (current is CallConnecting) {
      sessionId = null;
    } else if (current is CallActive) {
      sessionId = current.sessionId;
    }

    if (sessionId != null) {
      _callDatasource.clearActiveCall();
      await _callDatasource.endCallSession();
      await _endCallUsecase(EndCallParams(sessionId: sessionId));
    }

    emit(const CallState.idle());
  }

  Future<void> _onEndButtonPressed(
    CallEndButtonPressed event,
    Emitter<CallState> emit,
  ) async {
    final current = state;
    if (current is! CallActive) return;

    _callDatasource.clearActiveCall();
    await _callDatasource.endCallSession();
    await _endCallUsecase(EndCallParams(sessionId: current.sessionId));

    emit(CallState.ended(receiverName: current.receiverName));

    await Future.delayed(const Duration(seconds: 2));
    emit(const CallState.idle());
  }

  Future<void> _onSessionTimeout(
    CallSessionTimeout event,
    Emitter<CallState> emit,
  ) async {
    final current = state;
    String name = '';
    if (current is CallActive) {
      name = current.receiverName;
    }

    _callDatasource.clearActiveCall();
    await _callDatasource.endCallSession();

    emit(CallState.ended(receiverName: name));
    await Future.delayed(const Duration(seconds: 2));
    emit(const CallState.idle());
  }

  void _onParticipantJoined(
    CallParticipantJoined event,
    Emitter<CallState> emit,
  ) {
    final current = state;
    if (current is! CallActive) return;

    final updatedNames = [...current.participantNames, event.name];
    emit(current.copyWith(participantNames: updatedNames));
  }

  void _onParticipantLeft(CallParticipantLeft event, Emitter<CallState> emit) {
    final current = state;
    if (current is! CallActive) return;

    final updatedNames = current.participantNames
        .where((name) => name != event.name)
        .toList();
    emit(current.copyWith(participantNames: updatedNames));
  }

  void _onSessionStarted(CallSessionStarted event, Emitter<CallState> emit) {
    final current = state;
    if (current is! CallActive) return;

    emit(current.copyWith(sessionWidgetReady: true));
  }

  void _onDismissEnded(CallDismissEnded event, Emitter<CallState> emit) {
    emit(const CallState.idle());
  }

  // ─── Session Starter ───────────────────────────────────────────────────────

  /// Generates a call token and starts the call session.
  /// After the SDK returns the calling widget, it fires
  /// [CallSessionStarted] to let the UI know to render it.
  Future<void> _startSession(CallEntity call) async {
    // Get auth token
    final authResult = await _getCallAuthTokenUsecase(const NoParams());
    final authToken = authResult.fold((_) => '', (t) => t);
    if (authToken.isEmpty) {
      // Emit error synchronously via add
      add(const CallEnd()); // fallback
      return;
    }

    // Generate call token
    final tokenResult = await _callDatasource.generateCallToken(
      sessionId: call.sessionId,
      authToken: authToken,
    );

    final token = tokenResult.token;
    if (token == null || token.isEmpty) {
      add(const CallEnd());
      return;
    }

    // Build audio-only call settings
    final callSettings =
        (ccc.CallSettingsBuilder()
              ..enableDefaultLayout = true
              ..setAudioOnlyCall = true
              ..showSwitchToVideoCallButton = false
              ..showEndCallButton = true
              ..showMuteAudioButton = true
              ..showAudioModeButton = true
              ..showSwitchCameraButton = false
              ..showPauseVideoButton = true
              ..showCallRecordButton = false)
            .build();

    // Start the session — the SDK will call back via _callsListener / sessionEvents
    _callDatasource.startCallSession(
      token: ccc.GenerateToken(token: token),
      callSettings: callSettings,
    );
  }

  // ─── Calls SDK Listener ────────────────────────────────────────────────────

  final _callsListener = _CallBlocCallsListener();

  @override
  Future<void> close() async {
    await _sessionSubscription?.cancel();
    await _incomingSubscription?.cancel();
    _callDatasource.removeCallsEventListener(_listenerId);
    return super.close();
  }
}

/// Translates CometChatCalls SDK events into CallBloc events.
class _CallBlocCallsListener with ccc.CometChatCallsEventsListener {
  @override
  void onCallEnded() {
    // The end call flow is handled via sessionEvents stream
  }

  @override
  void onCallEndButtonPressed() {
    // Forwarded via CallDatasourceImpl.sessionEvents
  }

  @override
  void onUserJoined(ccc.RTCUser user) {
    // Forwarded via CallDatasourceImpl.sessionEvents
  }

  @override
  void onUserLeft(ccc.RTCUser user) {
    // Forwarded via CallDatasourceImpl.sessionEvents
  }

  @override
  void onUserListChanged(List<ccc.RTCUser> users) {}

  @override
  void onAudioModeChanged(List<ccc.AudioMode> devices) {}

  @override
  void onCallSwitchedToVideo(ccc.CallSwitchRequestInfo info) {}

  @override
  void onUserMuted(ccc.RTCMutedUser muteObj) {}

  @override
  void onRecordingToggled(ccc.RTCRecordingInfo info) {}

  @override
  void onError(ccc.CometChatCallsException ce) {}

  @override
  void onSessionTimeout() {
    // Forwarded via CallDatasourceImpl.sessionEvents
  }
}
