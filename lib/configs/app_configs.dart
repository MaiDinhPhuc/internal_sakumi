class AppConfigs{

  static const String endPoint = "http://173.199.127.90:3000";

  static const bool endpointFirebaseDebug = false;

  static String getDataUrl(String file, String token){
    return "$endPoint/api/v1/mobile/static/get/?token=$token&name=$file";
  }

  static String dir = "";
  static String defaultImage = 'https://cdn3.iconfinder.com/data/icons/education-1-28/49/144-512.png';
}