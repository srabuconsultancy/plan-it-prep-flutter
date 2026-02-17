class CouponModel {
  int total = 0;
  List<CouponItem> data = [];
  CouponModel();
  CouponModel.fromJSON(Map<String, dynamic> json) {
    data = json["data"] != null ? parseOrders(json["data"]) : [];
    total = json["total"] ?? 0;
  }
  List<CouponItem> parseOrders(response) {
    List list = response;
    List<CouponItem> attrList = list.map((data) => CouponItem.fromJSON(data)).toList();
    return attrList;
  }
}

class CouponItem {
  int id = 0;
  String title = '';
  String description = '';
  String code = '';
  String price = '';
  String discountType = ''; //flat', 'percent', 'b1g1
  String endDate = '';
  int status = 0;
  CouponItem();
  CouponItem.fromJSON(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    title = json["title"] ?? '';
    description = json["description"] ?? '';
    code = json["code"] ?? '';
    price = json["amount"] ?? '';
    discountType = json["discount_type"] ?? '';
    status = json["status"] ?? 0;
    endDate = json["end_date"] ?? '';
  }
}
