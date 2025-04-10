import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../di_container.dart';
import '../../data/banner_repository.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final BannerRepository bannerRepository;
  BannerCubit({required this.bannerRepository}) : super(BannerInitial());
  // Method to fetch banners and update the state
  Future<void> fetchBanners() async {
    try {
      emit(BannerLoading()); // Emit loading state
      final banners = await bannerRepository.fetchBanners();
      emit(BannerLoaded(banners)); // Emit success state with fetched banners
    } catch (e) {
      emit(BannerError(e.toString())); // Emit error state if something goes wrong
    }
  }
}
