class User {
  int id = 0;
  String name = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String username = "";
  String phone = "";
  String gender = "";
  String bio = "";
  // DateTime dob = DateTime.now();
  int age = 0;
  String accessToken = "";
  String userDP = "";
  String country = "";
  String city = "";
  String state = "";
  String loginType = "O";
  bool online = false;
  String appVersion = "";
  DateTime registeredAt = DateTime.now();
  double height = 0;
  double weight = 0;
  double targetWeight = 0;
  double dailyWater = 0;
  double dailyCalorieIntake = 0;
  double dailyCarbIntake = 0;
  double dailyFiberIntake = 0;
  double dailyProteinIntake = 0;
  double dailyFatsIntake = 0;
  DateTime? membershipStartDate;
  DateTime? membershipEndDate;

  User();

  User.fromJSON(Map<String, dynamic> json) {
    try {
      id = json['id'];
      firstName = json['fname'] ?? "";
      lastName = json['lname'] ?? '';
      name = json['full_name'] ?? "$firstName $lastName";
      username = json['username'];
      email = json['email'] ?? "";
      phone = json['phone'] ?? '';
      gender = json['gender'] ?? '';
      bio = json['bio'] ?? '';
      accessToken = json['token'] ?? '';
      age = json['age'] ?? 0;
      country = json['country_name'] ?? '';
      // userDP = json['image'] ?? '';
      userDP = 'https://avatar.iran.liara.run/public/34';

      loginType = json['login_type'] ?? 'O';
      height = double.parse(json['height'] ?? "0");
      weight = double.parse(json['weight'] ?? "0");
      targetWeight = double.parse(json['target_weight'] ?? "0");
      dailyWater = double.parse((json['daily_water'] ?? "0").toString());
      dailyCalorieIntake =
          double.parse((json['daily_calorie_intake'] ?? "0").toString());
      dailyCarbIntake =
          double.parse((json['daily_carbs_intake'] ?? "0").toString());
      dailyFiberIntake =
          double.parse((json['daily_fiber_intake'] ?? "0").toString());
      dailyProteinIntake =
          double.parse((json['daily_protein_intake'] ?? "0").toString());
      dailyFatsIntake =
          double.parse((json['daily_fats_intake'] ?? "0").toString());
      membershipStartDate = json['membership_start_date'] != null &&
              json['membership_start_date'] != ""
          ? DateTime.parse(json['membership_start_date'])
          : null;
      membershipEndDate = json['membership_end_date'] != null &&
              json['membership_end_date'] != ""
          ? DateTime.parse(json['membership_end_date'])
          : null;
      registeredAt = json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now();
    } catch (e) {
      //print("userDataError $e $s");
      id = 0;
      firstName = '';
      lastName = '';
      name = '';
      username = '';
      email = '';
      phone = '';
      gender = '';
      bio = '';
      // dob = DateTime.now();
      age = 0;
      country = '';
      membershipStartDate = DateTime.now();
      membershipEndDate = DateTime.now();
      registeredAt = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['mobile'] = phone;
    data['gender'] = gender;
    data['bio'] = bio;
    // data['dob'] = dob.toString();
    data['age'] = age;
    return data;
  }
}
