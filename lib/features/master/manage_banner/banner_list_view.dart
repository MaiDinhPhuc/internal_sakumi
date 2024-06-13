import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/master/manage_banner/add_banner_dialog.dart';
import 'package:internal_sakumi/features/master/manage_banner/manage_banner_cubit.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/resizable.dart';
import '../../admin/manage_general/dotted_border_button.dart';
import '../../admin/manage_tag/add_group_tag_dialog.dart';
import '../../admin/manage_tag/group_item.dart';

class BannerListView extends StatelessWidget {
  const BannerListView({super.key, required this.manageBannerCubit});
  final ManageBannerCubit manageBannerCubit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            AppText.txtListBanner.text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Resizable.font(context, 20),
                fontWeight: FontWeight.w600,
                color: darkPrimaryColor),
          ),
        ),
        if (manageBannerCubit.banners.isNotEmpty)
          Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Resizable.padding(context, 10)),
                    ...manageBannerCubit.banners.map((e) {
                      final index = manageBannerCubit.banners.indexOf(e);
                      return Padding(
                        padding:
                        EdgeInsets.only(bottom: Resizable.padding(context, 5)),
                        child: GroupItemV1(
                          isFocus: index == manageBannerCubit.bannerIndex,
                          title: e.title,

                          onEdit: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AddBannerDialog(
                                    manageBannerCubit: manageBannerCubit,
                                    bannerModel: e,
                                  );
                                });

                          },
                          onDelete: () {
                            Dialogs.alertDelete(
                                context, AppText.txtConfirmDeleteBanner.text,
                                    () async {
                                  bool value =
                                  await manageBannerCubit.deleteBanner(index);
                                  if (context.mounted) {
                                    if (value) {
                                      Fluttertoast.showToast(
                                          msg: AppText.txtDeleteSuccess.text);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: AppText.txtError.text);
                                    }
                                    Navigator.pop(context);
                                  }
                                });
                          },
                          onClick: () {
                            manageBannerCubit.setCurrentIndex(index);
                          },
                        ),
                      );
                    })
                  ],
                ),
              )),
        SizedBox(height: Resizable.padding(context, 10)),
        DottedBorderButton('+ ${AppText.txtAddBanner.text.toUpperCase()}',
            isManageGeneral: true, onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AddBannerDialog(manageBannerCubit: manageBannerCubit);
                  });
            }),
      ],
    );
  }
}
