import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/object_tag_item.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../../model/manage_tag_model.dart';
import '../../../../model/tag_model.dart';
import '../../../../routes.dart';

class StudentTagListView extends StatefulWidget {
  StudentTagListView({super.key, required this.list, required this.listTags})
      : studentTagCubit = StudentTagCubit(list , listTags);

  final List<ManageTagModel> list;
  final StudentTagCubit studentTagCubit;
  final List<TagModel> listTags;
  @override
  State<StudentTagListView> createState() => _StudentTagListViewState();
}

class _StudentTagListViewState extends State<StudentTagListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build again');
    return BlocProvider.value(
      value: widget.studentTagCubit..load(),
      child: BlocBuilder<StudentTagCubit, int>(
        builder: (context, state) {
          if (state == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final cubit = context.read<StudentTagCubit>();
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Resizable.padding(context, 15),
              vertical: Resizable.padding(context, 15),
            ),
            child: Column(
              children: [
                ...cubit.listStudentTags.map((e) => ObjectTagItem(
                    onTap: () async {
                      await Navigator.pushNamed(context,
                          "${Routes.admin}/studentInfo/student=${e.studentModel.userId}");
                    },
                    title: e.studentModel.name,
                    description: '${AppText.txtStudentCode.text}: ${e.studentModel.studentCode}',
                    prefixIcon: Image.network(
                      e.studentModel.url,
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

class StudentTagCubit extends Cubit<int> {
  StudentTagCubit(this.list, this.listTags) : super(0);
  final List<ManageTagModel> list;
  final List<TagModel> listTags;
  List<StudentTag> listStudentTags = [];

  Future<List<StudentModel>> getStudents(List<ManageTagModel> list) async {
    List<Future<StudentModel>> futures = [];
    for (var item in list) {
      futures.add(FireBaseProvider.instance.getStudentById(item.ownId));
    }
    List<StudentModel> students = await Future.wait(futures);
    return students;
  }
  load() async {
    var students = await getStudents(list);
    for (var item in list) {
      var student = students.where((element) => element.userId == item.ownId).first;
      var tags = <TagModel>[];
      for (var k in item.tags) {
        var tag = listTags.where((element) => element.id == (k as int)).first;
        tags.add(tag);
      }
      listStudentTags.add(StudentTag(
        studentModel: student,
        listTags: [...tags],
      ));
    }
    emit(state + 1);
  }
}

class StudentTag {
  final StudentModel studentModel;
  final List<TagModel> listTags;

  const StudentTag({
    required this.studentModel,
    required this.listTags,
  });
}
