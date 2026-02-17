import '../core.dart';

class LoginResponseModel {
  String status = "";
  User? data = User();

  LoginResponseModel({this.data, this.status = ""});

  factory LoginResponseModel.fromJSON(Map<String, dynamic> json) {
    return LoginResponseModel(
      data: json['content'] != null ? User.fromJSON(json['content']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
