import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/banner_model.dart';
import '../../../providers/firebase/firebase_provider.dart';

class ManageBannerCubit extends Cubit<int> {
  ManageBannerCubit() : super(0);


  List<BannerModel> banners = [];

  BannerModel? get currentBanner => banners.isEmpty ? null : banners[bannerIndex];
  int bannerIndex = 0;

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }

  load() async {
    banners = await FireBaseProvider.instance.getBanners();
    bannerIndex = 0;
    emitState();
  }

  setCurrentIndex(int index) {
    bannerIndex = index;
    emitState();
  }

  void updateBanner(BannerModel bannerModel, bool isEdit) {
    if(isEdit) {
      final index = banners.indexWhere((element) => element.id == bannerModel.id);
      if(index != -1) {
        banners.removeAt(index);
        banners.insert(index, bannerModel);
      }
    }
    else {
      banners.add(bannerModel);
      bannerIndex = banners.indexOf(bannerModel);
    }
    emitState();
  }

  Future<bool> deleteBanner(int index) async {

    var bannerTag = await FireBaseProvider.instance.getBannerOptionByIdAndType(banners[index].id, 1);
    var bannerCourse = await FireBaseProvider.instance.getBannerOptionByIdAndType(banners[index].id, 2);
    if(bannerTag != null) {
      await FireBaseProvider.instance.deleteBannerOption('banner_option_${bannerTag.id}');
    }
    if(bannerCourse != null) {
      await FireBaseProvider.instance.deleteBannerOption('banner_option_${bannerCourse.id}');
    }
    bool value =
        await FireBaseProvider.instance.deleteBanner('banner_${banners[index].id}');

    if (value) {
      banners.removeAt(index);
      if (index == bannerIndex) {
        bannerIndex = 0;
      }
      if (bannerIndex > index) {
        bannerIndex--;
      }
      emitState();
    }

    return value;
  }
}
