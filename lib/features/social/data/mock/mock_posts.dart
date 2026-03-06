import 'package:uit_buddy_mobile/features/social/domain/entities/post_entity.dart';

final List<PostEntity> mockPosts = [
  const PostEntity(
    id: '1',
    authorName: 'Đinh Minh Phan',
    authorClass: 'KTPM2023.2',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=1',
    content:
        'Just finished my Machine Learning project! The neural network finally achieved 95% accuracy. Anyone else working on AI projects this semester?',
    imageUrl: 'https://picsum.photos/seed/ml_project/600/400',
    timeAgo: '2 hours ago',
    likeCount: 24,
    commentCount: 10,
    shareCount: 3,
    isLiked: false,
  ),
  const PostEntity(
    id: '2',
    authorName: 'Nguyễn Thị Hồng',
    authorClass: 'CNTT2022.1',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=5',
    content:
        'Hôm nay lớp mình có buổi seminar về Cloud Computing cực hay! Ai chưa đăng ký khoá tiếp theo thì nhanh tay nhé 🔥',
    timeAgo: '3 hours ago',
    likeCount: 42,
    commentCount: 8,
    shareCount: 12,
    isLiked: true,
  ),
  const PostEntity(
    id: '3',
    authorName: 'Trần Văn Khoa',
    authorClass: 'KHMT2023.1',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=8',
    content:
        'Chia sẻ repo GitHub cho đồ án OOP. Star giúp mình nhé! Link trong comment 👇',
    imageUrl: 'https://picsum.photos/seed/github_repo/600/300',
    timeAgo: '5 hours ago',
    likeCount: 67,
    commentCount: 23,
    shareCount: 15,
    isLiked: false,
  ),
  const PostEntity(
    id: '4',
    authorName: 'Lê Hoàng Anh',
    authorClass: 'MMT2022.2',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=12',
    content:
        'Cuối cùng cũng pass được môn Mạng máy tính 😭 Cảm ơn anh chị khoá trên đã chia sẻ tài liệu!',
    timeAgo: '6 hours ago',
    likeCount: 156,
    commentCount: 34,
    shareCount: 5,
    isLiked: true,
  ),
  const PostEntity(
    id: '5',
    authorName: 'Phạm Quốc Bảo',
    authorClass: 'KTPM2024.1',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=15',
    content:
        'Ai có kinh nghiệm intern Flutter không ạ? Mình đang chuẩn bị apply mùa hè này, muốn xin tips từ các anh chị 🙏',
    imageUrl: 'https://picsum.photos/seed/flutter_dev/600/350',
    timeAgo: '8 hours ago',
    likeCount: 89,
    commentCount: 45,
    shareCount: 20,
    isLiked: false,
  ),
];
