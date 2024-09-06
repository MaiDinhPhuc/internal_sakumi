import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/input_form/input_field.dart';
import 'package:internal_sakumi/features/admin/manage_tag/custom_button_v1.dart';
import 'package:internal_sakumi/features/master/manage_course/alert_add_new_course.dart';
import 'package:internal_sakumi/model/admin_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class GiftCodeTab extends StatelessWidget {
  const GiftCodeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const MasterAppbar(s: 6),
            Expanded(
                child: Center(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocProvider(
                  create: (context) => SwitcherCubit(false)..loadGiftEnable(),
                  child: BlocBuilder<SwitcherCubit, bool>(
                    builder: (c, s) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Enable Gift Code",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 18),
                                  color: const Color(0xff757575))),
                          Switch(
                              value: s,
                              activeColor: primaryColor,
                              onChanged: (bool value) async {
                                BlocProvider.of<SwitcherCubit>(c).update();
                                await FireStoreDb.instance
                                    .updateGiftEnable(value);
                              })
                        ],
                      );
                    },
                  ),
                ),
                BlocProvider(
                  create: (context) => EditSuperSaleCubit()..loadSuperSale(),
                  child: BlocBuilder<EditSuperSaleCubit, int>(
                    builder: (cc, s) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Enable Super Sale",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: Resizable.font(context, 18),
                                  color: const Color(0xff757575))),
                          Switch(
                              value:
                                  BlocProvider.of<EditSuperSaleCubit>(cc).check,
                              activeColor: primaryColor,
                              onChanged: (bool value) async {
                                if (value) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddInfoGiftDialog(
                                          cubit: BlocProvider.of<
                                              EditSuperSaleCubit>(cc),
                                        );
                                      });
                                } else {
                                  BlocProvider.of<EditSuperSaleCubit>(cc)
                                      .update(
                                          value,
                                          BlocProvider.of<EditSuperSaleCubit>(
                                                  cc)
                                              .gift);
                                  await FireStoreDb.instance
                                      .updateSuperSaleEnable(value);
                                }
                              })
                        ],
                      );
                    },
                  ),
                )
              ],
            )))
          ],
        ));
  }
}

class AddInfoGiftDialog extends StatefulWidget {
  const AddInfoGiftDialog({super.key, required this.cubit});

  final EditSuperSaleCubit cubit;

  @override
  State<AddInfoGiftDialog> createState() => _AddInfoGiftDialogState();
}

class _AddInfoGiftDialogState extends State<AddInfoGiftDialog> {
  final TextEditingController titleCon = TextEditingController();
  final TextEditingController desCon = TextEditingController();
  EnableGiftModel? banner;

  bool get isEdit => widget.cubit.gift != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      titleCon.text = widget.cubit.gift!.title;
      desCon.text = widget.cubit.gift!.des;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditSuperSaleCubit, int>(
        bloc: widget.cubit,
        builder: (c, s) {
          return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 16))),
              child: Container(
                  padding: EdgeInsets.all(Resizable.padding(context, 20)),
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            bottom: Resizable.padding(context, 10)),
                        child: Text(
                          "Supper_Sale",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: Resizable.font(context, 20)),
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 10)),
                        child: Column(
                          children: [
                            InputItem(
                                title: AppText.txtTitle.text,
                                controller: titleCon,
                                errorText: AppText.txtPleaseInput.text),
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                            InputItem(
                              title: AppText.txtDescription.text,
                              controller: desCon,
                              isExpand: true,
                            ),
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                            ImageGiftCode(
                                giftCode: widget.cubit.gift!,
                                cubit: widget.cubit),
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                          ],
                        ),
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
                                  editHandler(context, widget.cubit);
                                },
                                textColor: Colors.white,
                                backgroundColor: primaryColor,
                                title: isEdit
                                    ? AppText.btnUpdate.text
                                    : AppText.btnAddNew.text),
                          ],
                        ),
                      ),
                    ],
                  )));
        });
  }

  editHandler(BuildContext context, EditSuperSaleCubit cubit) async {

    waitingDialog(context);

    String url = cubit.gift!.banner;

    if (cubit.imgData != null) {
      url = await FireBaseProvider.instance
          .uploadImageAndGetUrl(cubit.imgData!, 'banner', 'banner');
    }
    debugPrint('==============>url: $url');

    EnableGiftModel superSale = EnableGiftModel(
        enable: true,
        id: 1001,
        title: titleCon.text,
        des: desCon.text,
        banner: url);

    await FireStoreDb.instance.updateSuperSaleInfo(superSale);

    await cubit.update(true, cubit.gift);

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}

class ImageGiftCode extends StatelessWidget {
  const ImageGiftCode({super.key, required this.giftCode, required this.cubit});
  final EnableGiftModel giftCode;
  final EditSuperSaleCubit cubit;
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
        cubit.banner.isEmpty
            ? DottedBorder(
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
                        icon: Image.asset(
                          'assets/images/ic_add_image.png',
                          scale: 0.5,
                        ),
                        onPressed: () async {
                          Uint8List? imgData =
                              await ImagePickerWeb.getImageAsBytes();
                          if (imgData != null) {
                            cubit.setImage(imgData);
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
                ))
            : SizedBox(
                height: Resizable.size(context, 100),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: cubit.imgData == null
                              ? Image.network(
                                  cubit.gift!.banner,
                                  fit: BoxFit.fill,
                                )
                              : Image.memory(cubit.imgData!, fit: BoxFit.fill)),
                    )),
                    SizedBox(
                      width: Resizable.padding(context, 10),
                    ),
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
                              cubit.setImage(imgData);
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
        if (!cubit.validateImg)
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),
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

class EditSuperSaleCubit extends Cubit<int> {
  EditSuperSaleCubit() : super(0);

  EnableGiftModel? gift;
  Uint8List? imgData;
  bool validateImg = true;
  bool check = false;
  String banner = "";

  update(bool newCheck, EnableGiftModel? newGift) {
    check = newCheck;
    gift = newGift;
    emit(state + 1);
  }

  loadSuperSale() async {
    gift = await FireBaseProvider.instance.getEnableInAdmin(1001);
    check = gift!.enable;
    banner = gift!.banner;
    emit(state + 1);
  }

  setValidateImg(bool value) {
    validateImg = value;
    emit(state + 1);
  }

  setImage(Uint8List? value) {
    imgData = value;
    banner = "notEmpty";
    emit(state + 1);
  }
}
