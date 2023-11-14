import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_student/load_student_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_item.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

class ManageStudentsScreen extends StatelessWidget {
  const ManageStudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dataController = BlocProvider.of<DataCubit>(context);
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 0),
          Expanded(child:Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 150)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(
                      vertical: Resizable.padding(context, 20)),
                  child: Text(AppText.titleListStudent.text.toUpperCase(),
                      style: TextStyle(
                        fontSize: Resizable.font(context, 30),
                        fontWeight: FontWeight.w800,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Resizable.padding(context, 20),
                      vertical: Resizable.padding(context, 10)),
                  child: StudentItemRowLayout(
                      isHeader: true,
                      name: AppText.txtName.text,
                      phone: AppText.txtPhone.text,
                      code: AppText.txtStudentCode.text),
                ),
                Expanded(child: SingleChildScrollView(
                  child: BlocProvider(
                    create: (context) => LoadListStudentCubit()..loadFirst(),
                    child:
                    BlocBuilder<LoadListStudentCubit, int>(builder: (c, s) {
                      var cubit = BlocProvider.of<LoadListStudentCubit>(c);
                      return s == 0
                          ? Transform.scale(
                        scale: 0.75,
                        child: const CircularProgressIndicator(),
                      )
                          : Column(
                        children: [
                          ...List.generate(
                              cubit.listData.length,
                                  (index) => StudentInfoItem(
                                  cubit: cubit, index: index)).toList(),
                          SizedBox(height: Resizable.size(context, 5)),
                          DottedBorderButton(
                              AppText.btnManageStudent.text.toUpperCase(),
                              onPressed: () async {
                                if (c.mounted) {
                                  Navigator.pushNamed(context,
                                      '${Routes.admin}/${Routes.manageGeneral}');
                                }
                              }),
                          SizedBox(height: Resizable.size(context, 10)),
                          if (cubit.listData.length < cubit.totalCount!)
                            CustomButton(
                                onPress: () {
                                  cubit.loadMore();
                                },
                                bgColor: primaryColor,
                                foreColor: Colors.white,
                                text: AppText.txtLoadMore.text),
                          SizedBox(height: Resizable.size(context, 40)),
                        ],
                      );
                    }),
                  ),
                ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
