import 'package:get/get.dart';

import '../core.dart';

class LoginRequestModel {
  UserService authService = Get.find();
  int userId = 0;
  String name = "";
  String accessToken = '';
  String email = "";
  String username = "";
  String userDP = "";
  int isAnyUserFollow = 0;
  bool auth = false;
  bool isVerified = false;
  String loginType = "O";

  LoginRequestModel();

  LoginRequestModel.fromJSON(Map<String, dynamic> json) {
    if (json != {}) {
      // try {
      userId = json['user_id'] ?? 0;
      name = json['fname'] != null ? json['fname'] + (json['lname'] != null ? " ${json['lname']}" : '') : "";
      username = json['username'] ?? '';
      email = json['email'] ?? '';
      if (json['app_token'] != null) {
        accessToken = json['app_token'] ?? '';
      } else if (authService.currentUser.value.accessToken != '') {
        accessToken = authService.currentUser.value.accessToken;
      } else {
        accessToken = "";
      }
      userDP = json['user_dp'] ?? '';
      isVerified = json['isVerified'] != null
          ? json['isVerified'] == 1
              ? true
              : false
          : false;
      isAnyUserFollow = json['is_following_videos'] ?? 0;
      loginType = json['login_type'] ?? 'O';
      // } catch (e) {
      //   name = "";
      //   userName = "";
      //   email = "";
      //   token = "";
      //   //print(e);
      // }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = username;
    data['token'] = accessToken;
    data['email'] = email;
    data['name'] = name;
    data['userDP'] = userDP;
    data['isAnyUserFollow'] = isAnyUserFollow;
    data['isVerified'] = isVerified;
    return data;
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map['userId'] = userId;
    map['userName'] = username;
    map['token'] = accessToken;
    map['email'] = email;
    map['name'] = name;
    map['userDP'] = userDP;
    map['isAnyUserFollow'] = isAnyUserFollow;
    map['isVerified'] = isVerified;
    return map;
  }

  Map<String, dynamic> toSocialLoginMap(profile, timezone, type) {
    var map = <String, dynamic>{};
    map['fname'] = profile['first_name'] ?? "";
    map['lname'] = profile['last_name'] ?? "";
    map['email'] = profile['email'] ?? "";
    // map['email'] = "";
    map['gender'] = profile['gender'] ?? "";
    if (type == "FB") {
      map['user_dp'] = profile['picture']['data']['url'] ?? "";
    } else {
      map['user_dp'] = profile['user_dp'] ?? "";
    }
    map['dob'] = profile['birthday'] ?? "";
    map['time_zone'] = timezone;
    map['login_type'] = type;
    map['ios_uuid'] = profile['ios_uuid'] ?? "";
    map['ios_email'] = profile['ios_email'] ?? "";

    return map;
  }

  @override
  String toString() {
    var map = toMap();
    map["auth"] = auth;
    return map.toString();
  }
}
