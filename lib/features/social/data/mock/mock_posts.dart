import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/post_media_entity.dart';

final List<PostEntity> mockPosts = [
  PostEntity(
    id: '1',
    title: 'Machine Learning Project',
    authorName: 'Đinh Minh Phan',
    authorClass: 'KTPM2023.2',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=1',
    contentSnippet:
        'Just finished my Machine Learning project! The neural network finally achieved 95% accuracy. Anyone else working on AI projects this semester?',
    medias: const [
      PostMediaEntity(
        type: PostMediaType.image,
        url: 'https://picsum.photos/seed/ml_project/600/400',
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    likeCount: 24,
    commentCount: 10,
    shareCount: 3,
    isLiked: false,
  ),
  PostEntity(
    id: '2',
    title: 'Seminar Cloud Computing',
    authorName: 'Nguyễn Thị Hồng',
    authorClass: 'CNTT2022.1',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=5',
    contentSnippet:
        'Hôm nay lớp mình có buổi seminar về Cloud Computing cực hay! Ai chưa đăng ký khoá tiếp theo thì nhanh tay nhé 🔥',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    likeCount: 42,
    commentCount: 8,
    shareCount: 12,
    isLiked: true,
  ),
  PostEntity(
    id: '3',
    title: 'Repo GitHub Đồ Án OOP',
    authorName: 'Trần Văn Khoa',
    authorClass: 'KHMT2023.1',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=8',
    contentSnippet:
        'Chia sẻ repo GitHub cho đồ án OOP. Star giúp mình nhé! Link trong comment 👇',
    medias: const [
      PostMediaEntity(
        type: PostMediaType.image,
        url: 'https://picsum.photos/seed/github_repo/600/300',
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    likeCount: 67,
    commentCount: 23,
    shareCount: 15,
    isLiked: false,
  ),
  PostEntity(
    id: '4',
    title: 'Pass môn Mạng Máy Tính!',
    authorName: 'Lê Hoàng Anh',
    authorClass: 'MMT2022.2',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=12',
    contentSnippet:
        'Cuối cùng cũng pass được môn Mạng máy tính 😭 Cảm ơn anh chị khoá trên đã chia sẻ tài liệu!',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    likeCount: 156,
    commentCount: 34,
    shareCount: 5,
    isLiked: true,
  ),
  PostEntity(
    id: '5',
    title: 'Xin tips intern Flutter',
    authorName: 'Phạm Quốc Bảo',
    authorClass: 'KTPM2024.1',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=15',
    contentSnippet:
        'Ai có kinh nghiệm intern Flutter không ạ? Mình đang chuẩn bị apply mùa hè này, muốn xin tips từ các anh chị 🙏',
    medias: const [
      PostMediaEntity(
        type: PostMediaType.image,
        url: 'https://picsum.photos/seed/flutter_dev/600/350',
      ),
    ],
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    likeCount: 89,
    commentCount: 45,
    shareCount: 20,
    isLiked: false,
  ),
];
