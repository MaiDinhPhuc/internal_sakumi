import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/master/manage_banner/add_banner_cubit.dart';
import 'package:internal_sakumi/model/banner_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ImageBanner extends StatelessWidget {
  const ImageBanner({super.key, required this.addCubit, this.bannerModel});
  final AddBannerCubit addCubit;
  final BannerModel? bannerModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppText.txtImageBanner.text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Resizable.font(context, 18),
                color: const Color(0xff757575))),
        SizedBox(
          height: Resizable.padding(context, 8),
        ),
        addCubit.imgData == null && bannerModel == null ? DottedBorder(
            color: primaryColor,
            padding: EdgeInsets.zero,
            dashPattern: const [5, 3],
            borderType: BorderType.RRect,
            strokeCap: StrokeCap.round,
            radius: const Radius.circular(10),
            child: SizedBox(
              height: Resizable.size(context, 100),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: Resizable.size(context, 25),
                    icon: Image.asset('assets/images/ic_add_image.png', scale: 0.5,),
                    onPressed: () async {
                      Uint8List? imgData =
                          await ImagePickerWeb.getImageAsBytes();
                      if (imgData != null) {
                        addCubit.setImage(imgData);
                      }
                    },
                  ),
                  Text(AppText.txtUploadImage.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 14),
                          color: primaryColor)),
                ],
              ),
            )) : SizedBox(
          height: Resizable.size(context, 100),
          child: Row(
            children: [
              Expanded(child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: bannerModel != null && addCubit.imgData == null ? Image.network(bannerModel!.image, fit: BoxFit.fill,)  : Image.memory(addCubit.imgData!, fit: BoxFit.fill)),
              )),
              SizedBox(width: Resizable.padding(context, 10),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: Resizable.size(context, 25),
                    color: primaryColor,
                    icon: const Icon(Icons.change_circle_outlined),
                    onPressed: () async {
                      Uint8List? imgData =
                      await ImagePickerWeb.getImageAsBytes();
                      if (imgData != null) {
                        addCubit.setImage(imgData);
                      }
                    },
                  ),
                  Text(AppText.txtChangeImage.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 14),
                          color: primaryColor)),
                ],
              ),

            ],
          ),
        ),
        if(!addCubit.validateImg)
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: Resizable.padding(context, 5)
          ),
          child: Text('* ${AppText.txtPleaseInputImage.text}',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Resizable.font(context, 12),
                  color: primaryColor)),
        ),
      ],
    );
  }
}
