import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uit_buddy_mobile/features/home/domain/usecases/get_homepage_data_usecase.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home/home_event.dart';
import 'package:uit_buddy_mobile/features/home/presentation/bloc/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required GetHomepageDataUsecase getHomepageDataUsecase})
    : _getHomePageUsecase = getHomepageDataUsecase,
      super(const HomeState()) {
    on<HomeDataFetched>(_onHomeDataFetched);
  }

  final GetHomepageDataUsecase _getHomePageUsecase;

  Future<void> _onHomeDataFetched(
    HomeDataFetched event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getHomePageUsecase(const HomepageParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (homepageData) => emit(
        state.copyWith(
          status: HomeStatus.success,
          homepageData: homepageData,
          page: homepageData.paging.currentPage,
        ),
      ),
    );
  }
}
