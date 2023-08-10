enum AppText {
  titleMultiChoice,
  btnReplay,
  textHello,
  titleInfo,
  btnLogout,
  btnLogin,
  textEmail,
  textPassword,
  textChangePass,
  textOldPass,
  textNewPass,
  textConfirmPass,
  textOldPassRequired,
  textNewPassRequired,
  textConfirmPassRequired,
  textPassNotMatch,
  textNotImgPick,
  textGeneral,
  textKaiwa,
  textJlpt,
  textClassIsEmpty,
  textLessons,
  textLessonsIsEmpty,
  textClassNotChoose,
  titleSkill,
  titleListening,
  titleKanji,
  titleVocabulary,
  titleGrammar,
  btnStart,
  textTest,
  titleHomework,
  btnSubmit,
  txtSubmitted,
  txtNotSubmit,
  btnCheckResult,
  textTrue,
  textFalse,
  textQuestion,
  textAnswer,
  textYourAnswer,
  textOpenCamera,
  textOpenGallery,
  textCancel,

  titleAdmin,
  titleMaster,
  titleManageStudent,
  titleManageClass,
  titleManageTag,
  titleRole,
  titleUserId,
  btnSignUp,
  selectorStudent,
  selectorTeacher,
  txtName,
  txtPhone,
  txtNote,
  txtAvatar,
  txtTeacherCode,
  txtStudentCode,
  txtClassId,
  txtCourseId,
  txtClassCode,
  txtCourse,
  txtNumberOfLessons,
  txtRateOfAttendance,
  txtRateOfSubmitHomework,
  txtEvaluate,
  txtDescription,
  txtStartTime,
  txtEndTime,
  btnCreateClass,
  titleListClass,
  titleListStudent,
  titleListTeacher,
  btnAddNewClass,
  btnAddNewStudent,
  btnAddTeacher,
  btnUpdate,
  btnRemove,
  btnEdit,
  titleStatistics,
  titleAddStudent,
  titleAddTeacherToClass,
  txtNoStudent,
  txtNoClass,
  txtNoTag,
  txtNoTeacher,
  titleTagName,
  titleChooseBackground,
  titleChooseTextColor,
  btnAddTag,
  txtHello,
  txtSensei,
  txtLesson,
  txtNoteBeforeTeaching,
  txtNoteFromSupport,
  txtNoteFromAnotherTeacher,
  txtStartLesson,
  txtCompleteLesson,
  txtFinishLesson,
  txtQuantity,
  txtStudent,
  titleTimekeeping,
  txtPresent,
  txtNotPresent,
  txtAttendance,
  txtOutSoon,
  txtInLate,
  txtAbsent,
  txtPermitted,
  txtNotTimeKeeping,
  txtTest,
  txtPointOfTest,
  txtAveragePoint,
  txtDoHomeworks,
  txtNotMark,
  txtMarked,
  txtNoNoteForStudent,
  txtNoNoteForSupport,
  txtNoNoteForTeacher,
  txtHintNoteForStudent,
  txtHintNoteForSupport,
  txtHintNoteForTeacher,
  titleNoteForSenseiAfterTeach,
  txtNoteForSenseiAfterTeach,
  txtQuestionForSenseiAfterTeach,
  txtBack,
  txtOK,
  txtActiveStatus,
  txtLearningStatus,
  titleOverView,
  titleLesson,
  titleGrading,
  textClass,
  textNumberResultReceive,
  textQuestionNumber,
  titleQuestion,
  textStudentNotDo,
  textBack,
  textStudentAnswer,
  textGradingScale,
  textShowName,
  textGeneralComment,
  titleSlogan,
  titleSakumiCenter,
  txtMessageLogin,
  txtHintAccount,
  txtHintPassword,
  txtForgetPassword,
}

Map<AppText, String> texts = {
  AppText.textShowName: 'Hiện tên',
  AppText.textGeneralComment: 'Nhận xét chung',
  AppText.textGradingScale: 'Thang điểm',
  AppText.textStudentAnswer: 'Đáp án của Học viên: ',
  AppText.textBack: 'Quay về',
  AppText.textStudentNotDo: 'Học viên đã bỏ qua câu này!',
  AppText.titleQuestion: 'CÂU HỎI',
  AppText.textQuestionNumber: 'CÂU SỐ ',
  AppText.textNumberResultReceive: 'Số bài nhận được:',
  AppText.textClass: 'Lớp',
  AppText.titleOverView: 'Tổng quan',
  AppText.titleLesson: 'Bài học',
  AppText.titleGrading: 'Chấm điểm',
  AppText.titleMultiChoice: 'Kiểm tra',
  AppText.btnReplay: 'Làm lại',
  AppText.btnSubmit: 'Nộp bài',
  AppText.txtSubmitted: 'Đã nộp',
  AppText.txtNotSubmit: 'Chưa nộp',
  AppText.btnCheckResult: 'Chi tiết bài làm',
  AppText.textHello: 'Chào mừng tới SAKUMI',
  AppText.titleInfo: 'Thông tin cá nhân',
  AppText.btnLogin: 'Đăng nhập',
  AppText.btnLogout: 'Đăng xuất',
  AppText.textEmail: 'Email',
  AppText.textPassword: 'Mật khẩu',
  AppText.textChangePass: 'Đổi mật khẩu',
  AppText.textOldPass: 'Mật khẩu cũ',
  AppText.textNewPass: 'Mật khẩu mới',
  AppText.textConfirmPass: 'Xác nhận mật khẩu',
  AppText.textOldPassRequired: 'Mật khẩu cũ không được trống',
  AppText.textNewPassRequired: 'Mật khẩu mới không được trống',
  AppText.textConfirmPassRequired: 'Chưa xác nhận mật khẩu',
  AppText.textPassNotMatch: 'Mật khẩu xác nhận chưa khớp',
  AppText.textNotImgPick: 'Không có ảnh được chọn',
  AppText.textGeneral: 'Khoá học tổng hợp',
  AppText.textKaiwa: 'Khoá học Kaiwa',
  AppText.textJlpt: 'Khoá học JLPT',
  AppText.textClassIsEmpty: 'Bạn chưa đăng ký bất kì lớp học nào',
  AppText.textLessons: 'Danh sách bài học',
  AppText.textLessonsIsEmpty: 'Đang cập nhật bài học, vui lòng thử lại sau!',
  AppText.textClassNotChoose: 'Vui lòng chọn khóa học!',
  AppText.titleSkill: 'Luyện kỹ năng',
  AppText.titleListening: 'luyện nghe',
  AppText.titleKanji: 'kanji',
  AppText.titleVocabulary: 'từ vựng',
  AppText.titleGrammar: 'ngữ pháp',
  AppText.btnStart: 'Bắt đầu ngay',
  AppText.textTest: 'Đừng để những ngày tháng học tập của bạn trở nên vô nghĩa',
  AppText.titleHomework: 'Bài tập về nhà',
  AppText.textTrue: 'Đúng',
  AppText.textFalse: 'Sai',
  AppText.textQuestion: 'Câu hỏi:  ',
  AppText.textAnswer: 'Đáp án đúng:  ',
  AppText.textYourAnswer: 'Đáp án của bạn:  ',
  AppText.textOpenCamera: 'Chụp ảnh mới',
  AppText.textOpenGallery: 'Chọn ảnh từ thư viện',
  AppText.textCancel: 'Thoát',
  AppText.titleAdmin: 'Admin',
  AppText.titleMaster: 'Master',
  AppText.titleManageStudent: 'Quản lý học viên',
  AppText.titleManageClass: 'Quản lý lớp học',
  AppText.titleManageTag: 'Quản lý tag',
  AppText.titleRole: 'Vai trò',
  AppText.titleUserId: 'Mã người dùng',
  AppText.btnSignUp: 'Đăng ký',
  AppText.selectorStudent: 'student',
  AppText.selectorTeacher: 'teacher',
  AppText.txtName: 'Họ tên',
  AppText.txtPhone: 'Số điện thoại',
  AppText.txtNote: 'Ghi chú',
  AppText.txtTeacherCode: 'Mã giáo viên',
  AppText.txtStudentCode: 'Mã học viên',
  AppText.txtClassId: 'Mã định danh lớp',
  AppText.txtCourseId: 'Mã khoá học',
  AppText.txtClassCode: 'Mã lớp',
  AppText.txtCourse: 'Khoá học',
  AppText.txtNumberOfLessons: 'Số buổi học',
  AppText.txtRateOfAttendance: 'Tỉ lệ đi học',
  AppText.txtRateOfSubmitHomework: 'Tỉ lệ làm bài tập',
  AppText.txtEvaluate: 'Đánh giá',
  AppText.txtDescription: 'Mô tả',
  AppText.txtStartTime: 'Thời gian bắt đầu',
  AppText.txtEndTime: 'Thời gian kết thúc',
  AppText.btnCreateClass: 'Tạo lớp mới',
  AppText.titleListClass: 'Danh sách các lớp',
  AppText.titleListStudent: 'Danh sách học viên',
  AppText.titleListTeacher: 'Danh sách giáo viên',
  AppText.btnAddNewClass: 'Thêm lớp học mới',
  AppText.btnAddNewStudent: 'Thêm học viên mới',
  AppText.btnAddTeacher: 'Thêm giáo viên',
  AppText.btnUpdate: 'Cập nhật',
  AppText.btnRemove: 'Xoá',
  AppText.btnEdit: 'Sửa',
  AppText.titleStatistics: 'Thống kê',
  AppText.titleAddStudent: 'Thêm học viên',
  AppText.titleAddTeacherToClass: 'Thêm giáo viên vào lớp',
  AppText.txtNoStudent: 'Không có học viên',
  AppText.txtNoTeacher: 'Không có giáo viên',
  AppText.txtNoClass: 'Không có lớp học',
  AppText.txtNoTag: 'Không có thẻ',
  AppText.titleTagName: 'Tên thẻ',
  AppText.titleChooseBackground: 'Chọn màu nền',
  AppText.titleChooseTextColor: 'Chọn màu chữ',
  AppText.txtHello: 'Xin chào',
  AppText.txtSensei: 'sensei',
  AppText.txtLesson: 'Buổi',
  AppText.txtNoteBeforeTeaching: 'Dặn dò trước buổi học',
  AppText.txtNoteFromSupport: 'Ghi chú từ Team Support',
  AppText.txtNoteFromAnotherTeacher: 'Ghi chú từ Sensei',
  AppText.txtStartLesson: 'Bắt đầu buổi học',
  AppText.txtCompleteLesson: 'Hoàn thành buổi học',
  AppText.txtFinishLesson: 'Kết thúc buổi học',
  AppText.txtQuantity: 'Sỉ số',
  AppText.txtStudent: 'Học viên',
  AppText.titleTimekeeping: 'Điểm danh',
  AppText.txtPresent: 'Có mặt',
  AppText.txtNotPresent: 'Vắng mặt',
  AppText.txtAttendance: 'Đi học',
  AppText.txtOutSoon: 'Ra sớm',
  AppText.txtInLate: 'Vào trễ',
  AppText.txtAbsent: 'Nghỉ không phép',
  AppText.txtPermitted: 'Nghỉ có phép',
  AppText.txtNotTimeKeeping: 'Chưa điểm danh',
  AppText.txtTest: 'Bài kiểm tra',
  AppText.txtPointOfTest: 'Điểm kiểm tra',
  AppText.txtAveragePoint: '(Điểm trung bình)',
  AppText.txtDoHomeworks: 'Làm BTVN',
  AppText.txtNotMark: 'Chưa chấm bài tập về nhà',
  AppText.txtMarked: 'Đã chấm bài tập về nhà',
  AppText.txtNoNoteForStudent: 'Không có dặn dò dành cho học viên',
  AppText.txtNoNoteForSupport: 'Không có dặn dò dành cho Team Support',
  AppText.txtNoNoteForTeacher: 'Không có dặn dò dành cho Sensei',
  AppText.txtHintNoteForStudent: 'Điền ghi chú của Sensei dành cho học viên...',
  AppText.txtHintNoteForSupport: 'Điền ghi chú dành cho Team Support...',
  AppText.txtHintNoteForTeacher: 'Điền ghi chú dành cho Sensei tiếp theo...',
  AppText.titleNoteForSenseiAfterTeach: 'Dặn dò dành cho Sensei cuối buổi học',
  AppText.txtNoteForSenseiAfterTeach:
      'Sensei vui lòng tắt record Google Meet trước khi bấm đồng ý kết thúc buổi học',
  AppText.txtQuestionForSenseiAfterTeach:
      'Sensei có muốn kết thúc buổi học không?',
  AppText.txtOK: 'Đồng ý',
  AppText.txtBack: 'Quay lại',
  AppText.txtActiveStatus: 'Tương tác',
  AppText.txtLearningStatus: 'Học lực',
  AppText.titleSakumiCenter: 'Trung tâm Nhật ngữ Sakumi',
  AppText.titleSlogan: 'Tri thức truyền từ tâm',
  AppText.txtMessageLogin: 'Các sensei hãy đăng nhập để có thể sử dụng đầy đủ các chức năng hỗ trợ trong việc đứng lớp nhé!',
  AppText.txtHintAccount: 'abc123@gmail.com',
  AppText.txtHintPassword: 'abc123',
  AppText.txtForgetPassword: 'Quên mật khẩu'
};

extension AppTexts on AppText {
  static String getStringValue(String value) {
    return value;
  }

  String get text => texts[this] ?? '--TextNotFound--';
}
