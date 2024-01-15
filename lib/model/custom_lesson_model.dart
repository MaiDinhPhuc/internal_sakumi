class CustomLessonsModel {
  final int customLessonId;
  final String description, title;
  List<dynamic> lessonInfo;

  CustomLessonsModel(
      {required this.description,
      required this.customLessonId,
      required this.lessonInfo,
      required this.title});
}
