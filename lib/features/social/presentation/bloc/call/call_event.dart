import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object?> get props => [];
}

/// An incoming call was received (fired from the datasource listener).
class CallIncomingReceived extends CallEvent {
  final CallEntity call;

  const CallIncomingReceived(this.call);

  @override
  List<Object?> get props => [call];
}

/// User tapped the call button — initiate an outgoing audio call.
class CallInitiate extends CallEvent {
  final String receiverId;
  final bool isGroup;
  final String receiverName;
  final String receiverAvatar;

  const CallInitiate({
    required this.receiverId,
    required this.isGroup,
    required this.receiverName,
    this.receiverAvatar = '',
  });

  @override
  List<Object?> get props => [
    receiverId,
    isGroup,
    receiverName,
    receiverAvatar,
  ];
}

/// User accepted the incoming call.
class CallAccept extends CallEvent {
  const CallAccept();
}

/// User rejected the incoming call (or tapped "busy").
class CallReject extends CallEvent {
  final bool busy;

  const CallReject({this.busy = false});

  @override
  List<Object?> get props => [busy];
}

/// User (or the SDK UI) ended the active call.
class CallEnd extends CallEvent {
  const CallEnd();
}

/// SDK fired onCallEndButtonPressed — end session and clean up.
class CallEndButtonPressed extends CallEvent {
  const CallEndButtonPressed();
}

/// SDK fired onSessionTimeout.
class CallSessionTimeout extends CallEvent {
  const CallSessionTimeout();
}

/// A participant joined the call.
class CallParticipantJoined extends CallEvent {
  final String uid;
  final String name;

  const CallParticipantJoined({required this.uid, required this.name});

  @override
  List<Object?> get props => [uid, name];
}

/// A participant left the call.
class CallParticipantLeft extends CallEvent {
  final String uid;
  final String name;

  const CallParticipantLeft({required this.uid, required this.name});

  @override
  List<Object?> get props => [uid, name];
}

/// Internal: SDK returned the calling widget after session started.
class CallSessionStarted extends CallEvent {
  const CallSessionStarted();
}

/// Dismiss the ended-call banner and return to idle.
class CallDismissEnded extends CallEvent {
  const CallDismissEnded();
}
