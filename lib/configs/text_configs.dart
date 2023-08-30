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
  textChooseCourse,
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
  txtStartDate,
  txtEndDate,
  btnCreateClass,
  titleListClass,
  titleListStudent,
  titleListTeacher,
  btnAddNewClass,
  btnAddNewStudent,
  btnAddTeacher,
  btnAddNewTeacher,
  btnUpdate,
  btnRemove,
  btnEdit,
  titleStatistics,
  btnAddStudent,
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
  subjectLesson,
  txtLesson,
  titleNoteBeforeTeaching,
  titleNoteFromSupport,
  titleNoteFromAnotherTeacher,
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
  txtAgree,
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
  btnAdd,
  txtErrorStartDate,
  txtErrorEndDate,
  txtPleaseChooseCourse,
  txtPleaseInputClassCode,
  txtPleaseCheckListClass,
  txtPleaseCheckListUser,
  txtPleaseCheckListStudentInClass,
  txtPleaseSelect,
  txtPleaseInputName,
  txtPleaseInputPhone,
  txtPleaseInputStudentCode,
  txtPleaseInputTeacherCode,
  txtPleaseInputEmail,
  txtStudentInJapan,
  statusInProgress,
  txtWaiting,
  txtGradingDone,
  textNumberNotGrading,
  titleSubject,
  titleStatus,
  textSSNote,
  titleHome,
  txtTeacherProfile,
  txtChangeImage, txtBaseInfo, txtPassLogin,
  txtCurrentPass,
  txtNewPass,
  txtAgainNewPass,
  txtChangePass,
  txtExit,
  txtUpdate,
  optInProgress,
  optComplete,
  optBoth,
  txtFilter,
  textStudentNotSubmit,
  textContactIT,
  textDetail,
  txtLogout, txtTeacherLogOut,
  txtRateOfSubmitTest,
  textLesson,
  stsCompleted,
  stsDropped,
  stsMoved,
  stsRetained,
  stsInProgress,
  stsViewer,
  txtTestEmpty,
  txtNotGradingTest,
  txtAssignmentTest,
  txtSSConfirmAssignTest,
  txtNotGrading,
  txtWrongPassword,
  txtWrongAccount,
  stsRenew,
  stsRemove,
  stsUpSale
}

Map<AppText, String> texts = {
  AppText.stsUpSale: 'Lên cấp',
  AppText.stsRemove: 'Đã xoá',
  AppText.stsRenew: 'ReNew',
  AppText.txtNotGrading: 'Chưa chấm',
  AppText.txtSSConfirmAssignTest: 'Sensei có đồng ý giao bài hay không?',
  AppText.txtAssignmentTest: 'Giao bài kiểm tra',
  AppText.txtNotGradingTest: 'Chưa chấm bài kiểm tra',
  AppText.txtTestEmpty: 'Chưa có bài kiểm tra có thể giao trong lớp!',
  AppText.textLesson: 'Bài',
  AppText.txtRateOfSubmitTest: 'Tỉ lệ nộp bài',
  AppText.textDetail: 'Chi tiết',
  AppText.textStudentNotSubmit: 'Lớp chưa có ai nộp bài tập!',
  AppText.textContactIT: 'Lỗi khi load data, vui lòng liên hệ team IT để được support',
  AppText.titleHome: 'Trang chủ',
  AppText.textSSNote: 'Sensei hãy nhận xét về bài làm của Học viên nhé...',
  AppText.txtGradingDone: 'Chấm điểm xong!',
  AppText.textNumberNotGrading: 'Số bài chưa chấm: ',
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
  AppText.textChooseCourse: 'Chọn khóa học',
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
  AppText.txtStartDate: 'Ngày bắt đầu',
  AppText.txtEndDate: 'Ngày kết thúc',
  AppText.btnCreateClass: 'Tạo lớp mới',
  AppText.titleListClass: 'Danh sách các lớp',
  AppText.titleListStudent: 'Danh sách học viên',
  AppText.titleListTeacher: 'Danh sách giáo viên',
  AppText.btnAddNewClass: 'Thêm lớp học mới',
  AppText.btnAddNewStudent: 'Thêm học viên mới',
  AppText.btnAddTeacher: 'Thêm giáo viên',
  AppText.btnAddNewTeacher: 'Thêm giáo viên mới',
  AppText.btnUpdate: 'Cập nhật',
  AppText.btnRemove: 'Xoá',
  AppText.btnEdit: 'Sửa',
  AppText.titleStatistics: 'Thống kê',
  AppText.btnAddStudent: 'Thêm học viên',
  AppText.titleAddTeacherToClass: 'Thêm giáo viên vào lớp',
  AppText.txtNoStudent: 'Không có học viên',
  AppText.txtNoTeacher: 'Không có giáo viên',
  AppText.txtNoClass: 'Không có lớp học',
  AppText.txtNoTag: 'Không có thẻ',
  AppText.titleTagName: 'Tên thẻ',
  AppText.titleChooseBackground: 'Chọn màu nền',
  AppText.titleChooseTextColor: 'Chọn màu chữ',
  AppText.txtHello: 'Xin chào',
  AppText.txtSensei: 'Sensei',
  AppText.txtLesson: 'Buổi',
  AppText.subjectLesson: 'Buổi học',
  AppText.titleNoteBeforeTeaching: 'Dặn dò trước buổi học',
  AppText.titleNoteFromSupport: 'Ghi chú từ Team Support',
  AppText.titleNoteFromAnotherTeacher: 'Ghi chú từ Sensei',
  AppText.txtNoteBeforeTeaching:
      'Sensei vui lòng bật record Google Meet trước khi bắt đầu buổi học',
  AppText.txtNoteFromSupport:
      'Sensei vui lòng liên hệ số điện thoại 0xxxxxxxxx khi cần hỗ trợ về trang thiết bị',
  AppText.txtNoteFromAnotherTeacher:
      'Sensei vui lòng liên hệ số điện thoại 0xxxxxxxxx khi cần hỗ trợ về giảng dạy',
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
  AppText.txtAveragePoint: 'Điểm trung bình',
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
  AppText.txtAgree: 'Đồng ý',
  AppText.txtOK: 'OK',
  AppText.txtBack: 'Quay lại',
  AppText.txtActiveStatus: 'Tương tác',
  AppText.txtLearningStatus: 'Học lực',
  AppText.titleSakumiCenter: 'Trung tâm Nhật ngữ Sakumi',
  AppText.titleSlogan: 'Tri thức truyền từ tâm',
  AppText.txtMessageLogin:
      'Các sensei hãy đăng nhập để có thể sử dụng đầy đủ các chức năng hỗ trợ trong việc đứng lớp nhé!',
  AppText.txtHintAccount: 'abc123@gmail.com',
  AppText.txtHintPassword: 'abc123',
  AppText.txtForgetPassword: 'Quên mật khẩu',
  AppText.btnAdd: 'Thêm mới',
  AppText.txtErrorEndDate: 'Vui lòng chọn ngày kết thúc sau ngày bắt đầu',
  AppText.txtErrorStartDate: 'Vui lòng chọn ngày bắt đầu trước ngày kết thúc',
  AppText.txtPleaseChooseCourse: 'Vui lòng chọn khoá học',
  AppText.txtPleaseInputClassCode: 'Vui lòng nhập mã lớp học',
  AppText.txtPleaseCheckListClass:
      'Mã lớp đã tồn tại. Vui lòng kiểm tra lại danh sách lớp',
  AppText.txtPleaseCheckListUser:
      'Tài khoản này đã tồn tại. Vui lòng kiểm tra lại danh sách người dùng',
  AppText.txtPleaseCheckListStudentInClass:
      'Học viên này đã được thêm vào lớp. Vui lòng kiểm tra lại danh sách học viên trong lớp',
  AppText.txtPleaseSelect: 'Vui lòng lựa chọn',
  AppText.txtPleaseInputName: 'Vui lòng nhập tên',
  AppText.txtPleaseInputStudentCode: 'Vui lòng nhập mã học viên',
  AppText.txtPleaseInputTeacherCode: 'Vui lòng nhập mã giáo viên',
  AppText.txtPleaseInputEmail: 'Vui lòng nhập email',
  AppText.txtStudentInJapan: 'Học viên ở Nhật Bản',
  AppText.statusInProgress: 'InProgress',
  AppText.txtWaiting: 'Waiting...',
  AppText.titleSubject: 'Tựa đề bài',
  AppText.titleStatus: 'Trạng thái',
  AppText.optBoth: 'Cả 2',
  AppText.optInProgress: 'Đang diễn ra',
  AppText.optComplete: 'Đã kết thúc',
  AppText.txtFilter: 'Bộ lọc',
  AppText.txtTeacherProfile: 'Profile Giáo viên',
  AppText.txtChangeImage: 'Đổi ảnh mới',
  AppText.txtBaseInfo: 'Thông tin cơ bản',
  AppText.txtPassLogin: 'Mật khẩu đăng nhập',
  AppText.txtCurrentPass: 'Mật khẩu hiện tại',
  AppText.txtNewPass: 'Mật khẩu mới',
  AppText.txtAgainNewPass: 'Nhập lại mật khẩu mới',
  AppText.txtChangePass: 'Đổi mật khẩu',
  AppText.txtUpdate: 'Cập nhật',
  AppText.txtExit: 'Thoát',
  AppText.txtLogout: 'Đăng xuất',
  AppText.txtTeacherLogOut: 'Sensei có đồng ý đăng xuất hay không?',
  AppText.stsCompleted: 'Đã hoàn thành',
  AppText.stsDropped: 'Huỷ lớp',
  AppText.stsMoved: 'Chuyển lớp',
  AppText.stsRetained: 'Giữ lại',
  AppText.stsInProgress: 'Đang học',
  AppText.stsViewer: 'Người xem',
  AppText.txtWrongPassword: 'Vui lòng kiểm tra lại mật khẩu',
  AppText.txtWrongAccount: 'Vui lòng kiểm tra lại tài khoản',
};


extension AppTexts on AppText {
  static String getStringValue(String value) {
    return value;
  }

  String get text => texts[this] ?? '--TextNotFound--';
}
