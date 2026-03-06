import 'package:uit_buddy_mobile/features/social/domain/entities/message_entity.dart';

/// Returns mock messages for a given conversation id.
List<MessageEntity> getMockMessages(String conversationId) {
  return [
    MessageEntity(
      id: 'm1',
      senderId: 'other',
      senderName: 'Đinh Minh Phan',
      content: 'Hey! Bạn xong phần backend chưa?',
      time: '10:00',
      isMine: false,
    ),
    MessageEntity(
      id: 'm2',
      senderId: 'me',
      senderName: 'Minh',
      content: 'Chưa, mình đang fix bug phần authentication 😅',
      time: '10:02',
      isMine: true,
    ),
    MessageEntity(
      id: 'm3',
      senderId: 'other',
      senderName: 'Đinh Minh Phan',
      content: 'Oke, bạn cần giúp không? Phần đó mình làm xong rồi',
      time: '10:03',
      isMine: false,
    ),
    MessageEntity(
      id: 'm4',
      senderId: 'me',
      senderName: 'Minh',
      content: 'Cảm ơn! Mình gửi code cho bạn xem nhé',
      time: '10:05',
      isMine: true,
    ),
    MessageEntity(
      id: 'm5',
      senderId: 'other',
      senderName: 'Đinh Minh Phan',
      content: 'Oke send đây, mình check cho',
      time: '10:06',
      isMine: false,
    ),
    MessageEntity(
      id: 'm6',
      senderId: 'me',
      senderName: 'Minh',
      content: 'Đây nha: github.com/minhdp/auth-fix',
      time: '10:10',
      isMine: true,
    ),
    MessageEntity(
      id: 'm7',
      senderId: 'other',
      senderName: 'Đinh Minh Phan',
      content: 'Nhìn vào rồi, vấn đề ở chỗ bạn chưa refresh token đúng cách. Thêm middleware vào là được',
      time: '10:20',
      isMine: false,
    ),
    MessageEntity(
      id: 'm8',
      senderId: 'me',
      senderName: 'Minh',
      content: 'Aaaa hiểu rồi! Để mình fix thử',
      time: '10:22',
      isMine: true,
    ),
    MessageEntity(
      id: 'm9',
      senderId: 'other',
      senderName: 'Đinh Minh Phan',
      content: 'Bạn đã xem tài liệu mình gửi chưa?',
      time: '10:45',
      isMine: false,
    ),
  ];
}
