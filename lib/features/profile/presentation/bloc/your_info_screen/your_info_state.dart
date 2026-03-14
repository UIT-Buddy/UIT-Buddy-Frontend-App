import 'package:equatable/equatable.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';

class YourInfoState extends Equatable {
  final YourInfoEntity? yourInfo;
  final bool isLoading;
  final String? errorMessage;

  const YourInfoState({
    this.yourInfo,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [yourInfo, isLoading, errorMessage];

  YourInfoState copyWith({
    YourInfoEntity? yourInfo,
    bool? isLoading,
    String? errorMessage,
  }) {
    return YourInfoState(
      yourInfo: yourInfo ?? this.yourInfo,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}