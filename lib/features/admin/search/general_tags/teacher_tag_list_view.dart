import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/object_tag_item.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../../configs/text_configs.dart';
import '../../../../model/manage_tag_model.dart';
import '../../../../model/tag_model.dart';
import '../../../../routes.dart';

class TeacherTagListView extends StatefulWidget {
  TeacherTagListView({super.key, required this.list, required this.listTags})
      : teacherTagCubit = TeacherTagCubit(list, listTags);

  final List<ManageTagModel> list;
  final TeacherTagCubit teacherTagCubit;
  final List<TagModel> listTags;
  @override
  State<TeacherTagListView> createState() => _TeacherTagListViewState();
}

class _TeacherTagListViewState extends State<TeacherTagListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build again');
    return BlocProvider.value(
      value: widget.teacherTagCubit..load(),
      child: BlocBuilder<TeacherTagCubit, int>(
        builder: (context, state) {
          if (state == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final cubit = context.read<TeacherTagCubit>();
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 15),
              vertical: Resizable.padding(context, 15),
            ),
            child: Column(
              children: [
                ...cubit.listTeacherTags.map((e) => ObjectTagItem(
                    onTap: () async {
                      await Navigator.pushNamed(context,
                          "${Routes.admin}/teacherInfo/teacher=${e.teacherModel.userId}");
                    },
                    title: e.teacherModel.name,
                    description: "${AppText.txtTeacherCode.text}: ${e.teacherModel.teacherCode}",
                    prefixIcon: Image.network(
                      e.teacherModel.url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Image.asset("assets/images/ic_avt.png"),
                    ),
                    tags: e.listTags))
              ],
            ),
          );
        },
      ),
    );
  }
}

class TeacherTagCubit extends Cubit<int> {
  TeacherTagCubit(this.list, this.listTags) : super(0);
  final List<ManageTagModel> list;
  final List<TagModel> listTags;
  List<TeacherTag> listTeacherTags = [];

  Future<List<TeacherModel>> getTeachers(List<ManageTagModel> list) async {
    List<Future<TeacherModel>> futures = [];
    for (var item in list) {
      futures.add(FireBaseProvider.instance.getTeacherById(item.ownId));
    }
    List<TeacherModel> teachers = await Future.wait(futures);
    return teachers;
  }
  load() async {

    var teachers = await getTeachers(list);
    for (var item in list) {
      var tc = teachers.where((element) => element.userId == item.ownId).first;
      var tags = <TagModel>[];
      for (var k in item.tags) {
        var tag = listTags.where((element) => element.id == (k as int)).first;
        tags.add(tag);
      }
      listTeacherTags.add(TeacherTag(
        teacherModel: tc,
        listTags: [...tags],
      ));
    }

    emit(state + 1);
  }
}

class TeacherTag {
  final TeacherModel teacherModel;
  final List<TagModel> listTags;

  const TeacherTag({
    required this.teacherModel,
    required this.listTags,
  });
}

