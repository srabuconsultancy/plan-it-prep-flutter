import '../../core.dart';
import 'package:get/get.dart';

class PackageService extends GetxService {
  static PackageService get to => Get.find();
  var packages = <Package>[].obs;
  var currentPackage = Package().obs;
  var packageFeatures = <PackageFeature>[].obs;
  var appliedCouponValue = "".obs;
  String appliedCouponType = "";

  var couponCode = "".obs;

  var activeCouponsData = <CouponItem>[].obs;
}
