import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_tag/group_tag_view.dart';
import 'package:internal_sakumi/features/admin/manage_tag/manage_tag_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_tag/tag_view.dart';
import 'package:internal_sakumi/model/tag_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/textfield_widget.dart';

import '../../../features/admin/manage_general/dotted_border_button.dart';
import '../../../features/admin/manage_tag/group_item.dart';
import '../../../providers/firebase/firebase_provider.dart';

class ManageTagsScreen extends StatelessWidget {
  const ManageTagsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AdminAppBar(index: 2),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(
                top: Resizable.padding(context, 20),
                bottom: Resizable.padding(context, 20),
                left: Resizable.padding(context, 70),
                right: Resizable.padding(context, 70)),
            child: BlocProvider(
              create: (context) => ManageTagCubit()..load(),
              child: BlocBuilder<ManageTagCubit, int>(
                builder: (context, state) {
                  if(state == 0) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final manageTagCubit = context.read<ManageTagCubit>();
                  return Row(
                    children: [
                      Expanded(
                          child: GroupTagView(
                            manageTagCubit: manageTagCubit,
                          )),
                      SizedBox(width: Resizable.padding(context, 10),),
                      Expanded(flex: 2, child: TagView(
                        manageTagCubit: manageTagCubit,
                      ))
                    ],
                  );
                },
              ),
            ),
          ))
        ],
      ),
    );
  }

}

class ChooseTextColorCubit extends Cubit<bool> {
  ChooseTextColorCubit() : super(true);

  select() {
    emit(!state);
  }
}
