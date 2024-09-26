import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internal_sakumi/features/master/manage_banner/add_banner_cubit.dart';
import 'package:internal_sakumi/features/master/manage_banner/image_banner.dart';
import 'package:internal_sakumi/features/master/manage_banner/manage_banner_cubit.dart';
import 'package:internal_sakumi/model/banner_model.dart';

import '../../../configs/color_configs.dart';
import '../../../configs/text_configs.dart';
import '../../../providers/firebase/firebase_provider.dart';
import '../../../utils/enum.dart';
import '../../../utils/resizable.dart';
import '../../admin/manage_general/input_form/input_field.dart';
import '../../admin/manage_tag/custom_button_v1.dart';

class AddBannerDialog extends StatefulWidget {
  const AddBannerDialog(
      {super.key, required this.manageBannerCubit, this.bannerModel});

  final ManageBannerCubit manageBannerCubit;
  final BannerModel? bannerModel;

  @override
  State<AddBannerDialog> createState() => _AddBannerDialogState();
}

class _AddBannerDialogState extends State<AddBannerDialog> {
  final TextEditingController titleCon = TextEditingController();
  final TextEditingController textCon = TextEditingController();
  final TextEditingController desCon = TextEditingController();
  final TextEditingController htmlCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  BannerModel? banner;

  bool get isEdit => widget.bannerModel != null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isEdit) {
      titleCon.text = widget.bannerModel!.title;
      textCon.text = widget.bannerModel!.text;
      desCon.text = widget.bannerModel!.description;
      htmlCon.text = widget.bannerModel!.html;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBannerCubit(),
      child: BlocConsumer<AddBannerCubit, int>(
        listener: (context, state) {
          final addCubit = context.read<AddBannerCubit>();
          if (addCubit.status == SubmitStatus.success) {
            widget.manageBannerCubit.updateBanner(banner!, isEdit);
            Fluttertoast.showToast(msg:isEdit ?  AppText.txtUpdateSuccess.text : AppText.txtAddSuccess.text);
          } else if (addCubit.status == SubmitStatus.error) {
            Fluttertoast.showToast(msg: AppText.txtError.text);
          }
        },
        builder: (context, state) {
          return BlocBuilder<AddBannerCubit, int>(
            builder: (context, state) {
              final addCubit = context.read<AddBannerCubit>();
              return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(Resizable.size(context, 16))),
                  child: Container(
                      padding: EdgeInsets.all(Resizable.padding(context, 20)),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  bottom: Resizable.padding(context, 10)),
                              child: Text(
                                isEdit
                                    ? AppText.btnUpdateBanner.text
                                    .toUpperCase()
                                    : AppText.btnAddBanner.text.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                            ),
                            Expanded(child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 10)
                              ),
                              child: Column(children: [
                                InputItem(
                                    title: AppText.txtTitle.text,
                                    controller: titleCon,
                                    errorText: AppText
                                        .txtPleaseInput.text),
                                SizedBox(
                                  height: Resizable.padding(context, 10),
                                ),
                                InputItem(
                                  title: AppText.txtShortDescription.text,
                                  controller: textCon,
                                ),
                                InputItem(
                                  title: AppText.txtDescription.text,
                                  controller: desCon,
                                  isExpand: true,
                                ),
                                SizedBox(
                                  height: Resizable.padding(context, 10),
                                ),
                                InputItem(
                                  title: AppText.txtHtml.text,
                                  controller: htmlCon,
                                ),
                                SizedBox(
                                  height: Resizable.padding(context, 10),
                                ),
                                ImageBanner(
                                  addCubit: addCubit,
                                  bannerModel: widget.bannerModel,

                                ),
                                SizedBox(
                                  height: Resizable.padding(context, 10),
                                ),
                              ],),
                            )),
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomButtonV1(
                                      onPressed: () {
                                        if (addCubit.status !=
                                            SubmitStatus.none) {
                                          return;
                                        }
                                        Navigator.pop(context);
                                      },
                                      border: Colors.black,
                                      textColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      title: AppText.btnCancel.text),
                                  SizedBox(
                                    width: Resizable.padding(context, 5),
                                  ),
                                  CustomButtonV1(
                                      onPressed: () async {
                                        if (isEdit) {
                                          editHandler(
                                              context, addCubit);
                                        } else {
                                          addHandler(context, addCubit);
                                        }
                                      },
                                      textColor: Colors.white,
                                      backgroundColor: primaryColor,
                                      title: isEdit
                                          ? AppText.btnUpdate.text
                                          : AppText.btnAddNew.text),
                                ],
                              ),
                            ),
                            if (addCubit.status == SubmitStatus.loading)
                             ...[
                               SizedBox(height: Resizable.padding(context, 10),),
                               Center(
                                 child: Row(
                                   mainAxisSize: MainAxisSize.min,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text( isEdit ? AppText.txtLoadingUpdate.text :AppText.txtLoadingAdd.text),
                                     SizedBox(
                                       width: Resizable.padding(context, 10),
                                     ),
                                     SizedBox(
                                         height: Resizable.padding(context, 20),
                                         width: Resizable.padding(context, 20),
                                         child: const CircularProgressIndicator(
                                           color: primaryColor,
                                         )),
                                   ],
                                 ),
                               )
                             ]
                          ],
                        ),
                      )));
            },
          );
        },
      ),
    );
  }

  addHandler(BuildContext context, AddBannerCubit addCubit) async {
    if (addCubit.status != SubmitStatus.none) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if(addCubit.imgData == null) {
        addCubit.setValidateImg(false);
        return;
      }
      else {
        addCubit.setValidateImg(true);
      }

      addCubit.setSubmitStatus(SubmitStatus.loading);
      final url =
      await FireBaseProvider.instance.uploadImageAndGetUrl(addCubit.imgData!, 'banner', 'banner');
      debugPrint('==============>url: $url');
      banner = BannerModel(
          id: DateTime.now().millisecondsSinceEpoch,
          title: titleCon.text,
          text: textCon.text,
          image: url,
          description: desCon.text,
          html: htmlCon.text);

      await addCubit.addBanner(banner!);

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  editHandler(BuildContext context, AddBannerCubit addCubit) async {
    if (addCubit.status != SubmitStatus.none) {
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      addCubit.setSubmitStatus(SubmitStatus.loading);
      String url = '';
      if(addCubit.imgData != null) {
        url =
        await FireBaseProvider.instance.uploadImageAndGetUrl(addCubit.imgData!, 'banner', 'banner');
      }
      banner = widget.bannerModel!.copyWith(
        title: titleCon.text,
        text: textCon.text,
        html: htmlCon.text,
        image: url.isEmpty ? widget.bannerModel!.image : url,
        description: desCon.text,
      );
      if(compareBanners(banner!, widget.bannerModel!) && addCubit.imgData == null) {
        Fluttertoast.showToast(msg: AppText.txtDataNotChange.text);
        addCubit.setSubmitStatus(SubmitStatus.none);
        return;
      }
      await addCubit.addBanner(banner!);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  bool compareBanners(BannerModel banner1, BannerModel banner2) {
    return banner1 == banner2;
  }
}