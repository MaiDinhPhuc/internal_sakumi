import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/textfield_widget.dart';

class ManageTagTab extends StatelessWidget {
  final ChooseTextColorCubit cubit;
  final TextEditingController controller;
  ManageTagTab({Key? key})
      : cubit = ChooseTextColorCubit(),
        controller = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadListTagCubit(),
      child: BlocBuilder<LoadListTagCubit, List<TagModel>?>(
          builder: (c, list) => Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 200)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Resizable.size(context, 20)),
                          list == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : list.isEmpty
                                  ? Center(
                                      child: Text(AppText.txtNoTag.text),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ...list
                                            .map((e) => Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Resizable.padding(
                                                            context, 10),
                                                    vertical: Resizable.padding(
                                                        context, 5)),
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                      int.parse(e.background)),
                                                  border: Border.all(
                                                      color: primaryColor,
                                                      width: Resizable.size(
                                                          context, 1)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000),
                                                ),
                                                child: Text(e.title)))
                                            .toList(),
                                      ],
                                    ),
                          SizedBox(height: Resizable.size(context, 50)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(
                        bottom: Resizable.padding(context, 20),
                        right: Resizable.padding(context, 20)),
                    child: Stack(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: Resizable.size(context, 30),
                            height: Resizable.size(context, 30),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: Resizable.size(context, 5))
                                ]),
                            child: Icon(
                              Icons.add,
                              size: Resizable.size(context, 20),
                              color: Colors.white,
                            )),
                        Positioned.fill(
                            child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(1000),
                              onTap: () {
                                tagAlert(context);
                              }),
                        ))
                      ],
                    ),
                  )
                ],
              )),
    );
  }

  void tagAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 16))),
              child: Container(
                padding: EdgeInsets.all(Resizable.padding(context, 30)),
                constraints:
                    BoxConstraints(maxWidth: Resizable.size(context, 400)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldWidget(AppText.titleTagName.text, Icons.tag, false,
                        iconColor: primaryColor, controller: controller),
                    Row(
                      children: [
                        Text(AppText.titleChooseTextColor.text),
                        BlocBuilder<ChooseTextColorCubit, bool>(
                            bloc: cubit,
                            builder: (c, color) => DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    buttonDecoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(1000)),
                                    dropdownElevation: 0,
                                    dropdownDecoration: BoxDecoration(
                                        border: Border.all(color: primaryColor),
                                        color: primaryColor.shade100,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    items: [1, 2]
                                        .map((item) => DropdownMenuItem<int>(
                                            value: item,
                                            child: CircleAvatar(
                                              backgroundColor: item == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                            )))
                                        .toList(),
                                    value: color ? 1 : 2,
                                    onChanged: (v) => cubit.select(),
                                    buttonWidth: double.maxFinite,
                                  ),
                                ))
                      ],
                    ),
                    SizedBox(
                      height: Resizable.size(context, 30),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 30)))),
                      child: Text(AppText.btnAddTag.text),
                    ),
                  ],
                ),
              ));
        });
  }
}

class ChooseTextColorCubit extends Cubit<bool> {
  ChooseTextColorCubit() : super(true);

  select() {
    emit(!state);
  }
}

class LoadListTagCubit extends Cubit<List<TagModel>?> {
  LoadListTagCubit() : super(null);

  load() async {
    emit([]);
    //emit(await FireBaseProvider.instance.getTags());
  }
}
