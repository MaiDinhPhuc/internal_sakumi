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
  titleTest,
  btnSubmit,
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
  txtDescription,
  txtStartTime,
  txtEndTime,
  btnCreateClass,
  titleListClass,
  btnAddClass,
  btnAddStudent,
  btnAddTeacher,
  btnUpdate,
  btnRemove,
  btnEdit,
  titleDashboard,
  titleAddStudentToClass,
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
}

Map<AppText, String> texts = {
  AppText.titleMultiChoice: 'Kiểm tra',
  AppText.btnReplay: 'Làm lại',
  AppText.btnSubmit: 'Nộp bài',
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
  AppText.textGeneral: 'Tổng hợp',
  AppText.textKaiwa: 'Kaiwa',
  AppText.textJlpt: 'Jlpt',
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
  AppText.titleTest: 'Bài tập về nhà',
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
  AppText.txtName: 'Họ tên người dùng',
  AppText.txtPhone: 'Số điện thoại',
  AppText.txtNote: 'Ghi chú',
  AppText.txtTeacherCode: 'Mã giáo viên',
  AppText.txtStudentCode: 'Mã học viên',
  AppText.txtClassId: 'Mã định danh lớp',
  AppText.txtCourseId: 'Mã khoá học',
  AppText.txtClassCode: 'Mã lớp',
  AppText.txtDescription: 'Mô tả',
  AppText.txtStartTime: 'Thời gian bắt đầu',
  AppText.txtEndTime: 'Thời gian kết thúc',
  AppText.btnCreateClass: 'Tạo lớp mới',
  AppText.titleListClass: 'Danh sách lớp học',
  AppText.btnAddClass: 'Thêm lớp học',
  AppText.btnAddStudent: 'Thêm học viên',
  AppText.btnAddTeacher: 'Thêm giáo viên',
  AppText.btnUpdate: 'Cập nhật',
  AppText.btnRemove: 'Xoá',
  AppText.btnEdit: 'Sửa',
  AppText.titleDashboard: 'Thống kê',
  AppText.titleAddStudentToClass: 'Thêm học viên vào lớp',
  AppText.titleAddTeacherToClass: 'Thêm giáo viên vào lớp',
  AppText.txtNoStudent: 'Không có học viên',
  AppText.txtNoTeacher: 'Không có giáo viên',
  AppText.txtNoClass: 'Không có lớp học',
  AppText.txtNoTag: 'Không có thẻ',
  AppText.titleTagName: 'Tên thẻ',
  AppText.titleChooseBackground: 'Chọn màu nền',
  AppText.titleChooseTextColor: 'Chọn màu chữ',
  AppText.txtHello: 'Xin chào',
  AppText.txtSensei: 'sensei!',
};

extension AppTexts on AppText {
  static String getStringValue(String value) {
    return value;
  }

  String get text => texts[this] ?? '--TextNotFound--';
}
