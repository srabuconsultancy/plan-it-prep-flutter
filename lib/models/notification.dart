class NotificationModel {
  int id = 0;
  int notifyBy = 0;
  int notifyTo = 0;
  String title = "";
  String message = "";
  String? type;
  int read = 0;
  String createdAt = "";
  String updatedAt = "";
  String pageName = "";
  String? readOn;
  String addedOn = "";

  NotificationModel();

  NotificationModel.fromJson(Map<String, dynamic> json) {
    // Print some info about the parsing process (optional)

    try {
      id = json['id'] ?? 0;
      notifyBy = json['notify_by'] ?? 0;
      notifyTo = json['notify_to'] ?? 0;
      title = json['title'] ?? "";
      message = json['message'] ?? "";
      type = json['type'];
      read = json['read'] ?? 0;
      createdAt = json['created_at'] ?? "";
      updatedAt = json['updated_at'] ?? "";
      pageName = json['page_name'] ?? "";
      readOn = json['read_on'];
      addedOn = json['added_on'] ?? "";
    } catch (e) {
      //print("NotificationModel.fromJson error $e $s");
      id = 0;
      notifyBy = 0;
      notifyTo = 0;
      title = "";
      message = "";
      type = null;
      read = 0;
      createdAt = "";
      updatedAt = "";
      pageName = "";
      readOn = null;
      addedOn = "";
    }
  }

  Map<String, dynamic> toJson() {
    // //print("toJson this $this");
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['notify_by'] = notifyBy;
    data['notify_to'] = notifyTo;
    data['title'] = title;
    data['message'] = message;
    data['type'] = type;
    data['read'] = read;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['page_name'] = pageName;
    data['read_on'] = readOn;
    data['added_on'] = addedOn;
    return data;
  }
}
