import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/features/class_info/test/test_cubit_v2.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class CustomTestCubit extends Cubit<int> {
  CustomTestCubit(this.classModel) : super(0) {
    loadData();
  }

  ClassModel classModel;

  Map testInfo = {};

  List<CourseModel>? courses;
  List<TestModel> tests = [];

  loadData() async {
    courses = (await FireBaseProvider.instance.getAllCourseEnable())
        .where((e) => e.courseId != 999999999 && e.courseId != classModel.courseId)
        .toList();
    emit(state + 1);
  }

  chooseCourse(String? text) async {
    CourseModel course = courses!.singleWhere((element) =>
        '${element.title} ${element.termName} ${element.code}' == text);
    int courseId = course.courseId;
    testInfo = {"course_id": courseId};
    await DataProvider.customTests(courseId, loadTest);
  }

  List<String> listTestTitle() {
    return tests
        .where((e) => e.courseId == testInfo["course_id"])
        .toList()
        .map((e) => e.title)
        .toList();
  }

  chooseTest(String? text) async {
    TestModel test = tests
        .where((e) => e.courseId == testInfo["course_id"])
        .toList()
        .singleWhere((element) => element.title == text);
    CourseModel course = courses!
        .singleWhere((element) => element.courseId == testInfo["course_id"]);
    testInfo = {
      "course_id": test.courseId,
      "test_id": test.id,
      "custom_test_id": DateTime.now().millisecondsSinceEpoch,
      "token": course.btvnToken
    };
    emit(state + 1);
  }

  String findCourse() {
    if (testInfo == {}) return AppText.textChooseCourse.text;
    for (var i in courses!) {
      if (i.courseId == testInfo["course_id"]) {
        return '${i.title} ${i.termName} ${i.code}';
      }
    }
    return AppText.textChooseCourse.text;
  }

  String findTest() {
    if (testInfo == {}) return AppText.txtChooseTest.text;
    for (var i in tests) {
      if (i.id == testInfo["test_id"]) {
        return i.title;
      }
    }
    return AppText.txtChooseTest.text;
  }

  delete() {
    testInfo = {};
    emit(state + 1);
  }

  updateClass(TestCubitV2 listTestCubit) async {
    List<dynamic> listCustomLesson = classModel.customTests;

    List<Map> list = [];
    for (var i in listCustomLesson) {
      list.add({
        "course_id": i['course_id'],
        "test_id": i['test_id'],
        "custom_test_id": i['custom_test_id'],
        "token": i['token']
      });
    }

    list.add(testInfo);

    ClassModel newClass = ClassModel(
        classId: classModel.classId,
        courseId: classModel.courseId,
        description: classModel.description,
        endTime: classModel.endTime,
        startTime: classModel.startTime,
        note: classModel.note,
        classCode: classModel.classCode,
        classStatus: classModel.classStatus,
        classType: classModel.classType,
        link: classModel.link,
        customLessons: classModel.customLessons,
        informal: classModel.informal,
        isSubClass: classModel.isSubClass,
        subClassId: classModel.subClassId,
        customTests: list);

    await Update.updateClassInfo(newClass);
    listTestCubit.updateClass(newClass);
    TestModel test = tests.singleWhere((e) => e.id == testInfo["test_id"]);
    await listTestCubit.addNewTest(TestModel(
        id: testInfo['custom_test_id'],
        title: test.title,
        difficulty: 0,
        courseId: testInfo['course_id'],
        description: test.description,
        enable: true,
        duration: 0,
        isCustom: true,
        childTestId: testInfo['test_id'], analysis: 0));
    await DataProvider.updateCustomTest(listTestCubit.classModel!.courseId,listTestCubit.classModel!.classId, listTestCubit.listTest!);
  }

  loadTest(Object lessons) {
    List<TestModel> newList = lessons as List<TestModel>;

    for (var i in newList) {
      if (!tests.contains(i)) {
        tests.add(i);
      }
    }
    emit(state + 1);
  }
}
