import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/homepage_entity.dart';

part 'home_state.freezed.dart';

enum HomeStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    HomePageEntity? homepageData,
    @Default(1) int page,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _HomeState;
}
