class AppConfigs{

  static const String endPoint = "http://173.199.127.90:3000";

  static const bool endpointFirebaseDebug = true;

  static String getDataUrl(String file, String token){
    //e6cceec3aec49617978e81ec107d6b618738f757547c602a8fdd2af2cfd5836d721ba6c2943e38f5914adb2eaccdfb9cf3ce4f97fe50ce5f81d6fa4b20a45f14/btvn_102501.json
    return "https://noibo.sakumi.edu.vn/files/$token/$file";
  }

  static String dir = "";
  static String defaultImage = 'https://cdn3.iconfinder.com/data/icons/education-1-28/49/144-512.png';
}