import 'package:uit_buddy_mobile/features/social/domain/entities/chat_member_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/shared_media_entity.dart';

// ---------------------------------------------------------------------------
// Members
// ---------------------------------------------------------------------------

const _membersC3 = <ChatMemberEntity>[
  ChatMemberEntity(
    id: 'm1',
    name: 'Đinh Minh Phan',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    nickname: 'Phan Dev',
    isAdmin: true,
    isOnline: true,
  ),
  ChatMemberEntity(
    id: 'me',
    name: 'Minh (Bạn)',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    nickname: 'Minh',
    isAdmin: false,
    isOnline: true,
  ),
  ChatMemberEntity(
    id: 'm3',
    name: 'Nguyễn Thị Hồng',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    isAdmin: false,
    isOnline: false,
  ),
  ChatMemberEntity(
    id: 'm4',
    name: 'Trần Văn Khoa',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
    nickname: 'Khoa BE',
    isAdmin: false,
    isOnline: false,
  ),
  ChatMemberEntity(
    id: 'm5',
    name: 'Lê Hoàng Anh',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    isAdmin: false,
    isOnline: true,
  ),
];

const _membersC6 = <ChatMemberEntity>[
  ChatMemberEntity(
    id: 'prof1',
    name: 'GV. Nguyễn Văn Thắng',
    avatarUrl: 'https://i.pravatar.cc/150?img=50',
    isAdmin: true,
    isOnline: false,
  ),
  ChatMemberEntity(
    id: 'me',
    name: 'Minh (Bạn)',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    isAdmin: false,
    isOnline: true,
  ),
  ChatMemberEntity(
    id: 's1',
    name: 'Phạm Quốc Bảo',
    avatarUrl: 'https://i.pravatar.cc/150?img=15',
    isAdmin: false,
    isOnline: false,
  ),
  ChatMemberEntity(
    id: 's2',
    name: 'Đỗ Thị Mai',
    avatarUrl: 'https://i.pravatar.cc/150?img=44',
    isAdmin: false,
    isOnline: true,
  ),
  ChatMemberEntity(
    id: 's3',
    name: 'Lý Tuấn Kiệt',
    avatarUrl: 'https://i.pravatar.cc/150?img=22',
    isAdmin: false,
    isOnline: false,
  ),
  ChatMemberEntity(
    id: 's4',
    name: 'Võ Hồng Nhung',
    avatarUrl: 'https://i.pravatar.cc/150?img=47',
    isAdmin: false,
    isOnline: false,
  ),
];

List<ChatMemberEntity> getMockMembers(String conversationId) {
  switch (conversationId) {
    case 'c3':
      return _membersC3;
    case 'c6':
      return _membersC6;
    default:
      return [];
  }
}

// ---------------------------------------------------------------------------
// Nicknames
// ---------------------------------------------------------------------------

Map<String, String> getMockNicknames(String conversationId) {
  switch (conversationId) {
    case 'c2':
      return {'me': 'Mình', 'm_c2': 'Phan'};
    case 'c3':
      return {'me': 'Minh', 'm1': 'Phan Dev', 'm4': 'Khoa BE'};
    default:
      return {};
  }
}

// ---------------------------------------------------------------------------
// Shared media & files
// ---------------------------------------------------------------------------

List<SharedMediaEntity> getMockSharedMedia(String conversationId) {
  return [
    SharedMediaEntity(
      id: 'img1',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat1/300/300',
      sharedAt: DateTime(2026, 3, 8, 14, 20),
    ),
    SharedMediaEntity(
      id: 'img2',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat2/300/300',
      sharedAt: DateTime(2026, 3, 7, 10, 0),
    ),
    SharedMediaEntity(
      id: 'img3',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat3/300/300',
      sharedAt: DateTime(2026, 3, 6, 9, 30),
    ),
    SharedMediaEntity(
      id: 'img4',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat4/300/300',
      sharedAt: DateTime(2026, 3, 5, 18, 45),
    ),
    SharedMediaEntity(
      id: 'img5',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat5/300/300',
      sharedAt: DateTime(2026, 3, 4, 11, 10),
    ),
    SharedMediaEntity(
      id: 'img6',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat6/300/300',
      sharedAt: DateTime(2026, 3, 3, 16, 0),
    ),
    SharedMediaEntity(
      id: 'img7',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat7/300/300',
      sharedAt: DateTime(2026, 3, 2, 8, 0),
    ),
    SharedMediaEntity(
      id: 'img8',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat8/300/300',
      sharedAt: DateTime(2026, 3, 1, 15, 55),
    ),
    SharedMediaEntity(
      id: 'img9',
      type: SharedMediaType.image,
      url: 'https://picsum.photos/seed/chat9/300/300',
      sharedAt: DateTime(2026, 2, 28, 20, 0),
    ),
    SharedMediaEntity(
      id: 'file1',
      type: SharedMediaType.file,
      url: '',
      fileName: 'De_cuong_mon_CNPM.pdf',
      fileSize: '2.4 MB',
      sharedAt: DateTime(2026, 3, 7, 9, 0),
    ),
    SharedMediaEntity(
      id: 'file2',
      type: SharedMediaType.file,
      url: '',
      fileName: 'Bai_tap_tuan_8.docx',
      fileSize: '512 KB',
      sharedAt: DateTime(2026, 3, 5, 20, 0),
    ),
    SharedMediaEntity(
      id: 'file3',
      type: SharedMediaType.file,
      url: '',
      fileName: 'Slide_chuong_4.pptx',
      fileSize: '8.1 MB',
      sharedAt: DateTime(2026, 3, 3, 8, 30),
    ),
    SharedMediaEntity(
      id: 'file4',
      type: SharedMediaType.file,
      url: '',
      fileName: 'schedule_hk2_2025.xlsx',
      fileSize: '134 KB',
      sharedAt: DateTime(2026, 2, 27, 13, 0),
    ),
  ];
}
