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
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';

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
                  create: (context) => EditSuperSaleCubit()..loadSuperSale(),
                  child: BlocBuilder<EditSuperSaleCubit, int>(
                    builder: (cc, s) {
                      return InkWell(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return GiftAndSuperSaleDialog(
                                  cubit:
                                      BlocProvider.of<EditSuperSaleCubit>(cc),
                                );
                              });
                        },
                        child: Container(
                          width: Resizable.size(context, 250),
                          height: Resizable.size(context, 50),
                          padding: EdgeInsets.all(Resizable.size(context, 5)),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Color(0xFFDADADA),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Center(
                              child: Text(
                            "Gift and SuperSale Management",
                            style: TextStyle(
                              color: darkPrimaryColor,
                              fontSize: Resizable.font(context, 16),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          )),
                        ),
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

class GiftAndSuperSaleDialog extends StatefulWidget {
  const GiftAndSuperSaleDialog({super.key, required this.cubit});

  final EditSuperSaleCubit cubit;

  @override
  State<GiftAndSuperSaleDialog> createState() => _GiftAndSuperSaleDialogState();
}

class _GiftAndSuperSaleDialogState extends State<GiftAndSuperSaleDialog> {
  final TextEditingController titleCon = TextEditingController();
  final TextEditingController desCon = TextEditingController();
  final TextEditingController typeCon = TextEditingController();
  EnableGiftModel? banner;

  bool get isEdit => widget.cubit.gift != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      titleCon.text = widget.cubit.gift!.title;
      desCon.text = widget.cubit.gift!.des;
      typeCon.text = widget.cubit.gift!.type.toString();
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
                          "Management",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            InputItem(
                                title: 'Type',
                                controller: typeCon,
                                errorText: AppText.txtPleaseInput.text),
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Enable Gift",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575))),
                                Switch(
                                    value:
                                    widget.cubit.enableGift,
                                    activeColor: primaryColor,
                                    onChanged: (bool value) async {
                                      widget.cubit.setEnableGift();
                                    })
                              ],
                            ),
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Enable Super Sale Android",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575))),
                                Switch(
                                    value:
                                    widget.cubit.enableAndroid,
                                    activeColor: primaryColor,
                                    onChanged: (bool value) async {
                                      widget.cubit.setEnableAndroid();
                                    })
                              ],
                            ),
                            SizedBox(
                              height: Resizable.padding(context, 10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Enable Super Sale IOS",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Resizable.font(context, 18),
                                        color: const Color(0xff757575))),
                                Switch(
                                    value:
                                    widget.cubit.enableIOS,
                                    activeColor: primaryColor,
                                    onChanged: (bool value) async {
                                      widget.cubit.setEnableIOS();
                                    })
                              ],
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

    EnableGiftModel superSale = EnableGiftModel(
        enableGift: cubit.enableGift,
        id: 1001,
        title: titleCon.text,
        des: desCon.text,
        banner1: cubit.listImg[0],
        banner2: cubit.listImg[1],
        banner3: cubit.listImg[2],
        enableAndroid: cubit.enableAndroid,
        enableIOS: cubit.enableIOS,
        type: int.parse(typeCon.text));

    await FireStoreDb.instance.updateSuperSaleInfo(superSale);

    await cubit.loadSuperSale();

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
        for (int i = 0; i < cubit.listImg.length; i++)
          cubit.listImg[i].isEmpty
              ? Padding(
                  padding:
                      EdgeInsets.only(bottom: Resizable.padding(context, 10)),
                  child: DottedBorder(
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
                                  final url = await FireBaseProvider.instance
                                      .uploadImageAndGetUrl(
                                          imgData,
                                          'files',
                                          DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString());
                                  cubit.setImage(url, i);
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
                      )))
              : Container(
                  margin:
                      EdgeInsets.only(bottom: Resizable.padding(context, 10)),
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
                            child: Image.network(
                              cubit.listImg[i],
                              fit: BoxFit.fill,
                            )),
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
                                final url = await FireBaseProvider.instance
                                    .uploadImageAndGetUrl(
                                        imgData,
                                        'files',
                                        DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString());
                                cubit.setImage(url, i);
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
      ],
    );
  }
}

class EditSuperSaleCubit extends Cubit<int> {
  EditSuperSaleCubit() : super(0);

  EnableGiftModel? gift;
  List<String> listImg = ["", "", ""];

  bool enableGift = false;
  bool enableIOS = false;
  bool enableAndroid = false;

  loadSuperSale() async {
    gift = await FireBaseProvider.instance.getEnableInAdmin(1001);
    listImg = [gift!.banner1, gift!.banner2, gift!.banner3];
    enableGift = gift!.enableGift;
    enableIOS = gift!.enableIOS;
    enableAndroid = gift!.enableAndroid;
    emit(state + 1);
  }

  setImage(String url, int index) {
    listImg[index] = url;
    emit(state + 1);
  }

  setEnableGift() {
    enableGift = !enableGift;
    emit(state + 1);
  }

  setEnableIOS() {
    enableIOS = !enableIOS;
    emit(state + 1);
  }

  setEnableAndroid() {
    enableAndroid = !enableAndroid;
    emit(state + 1);
  }
}
