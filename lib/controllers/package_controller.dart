import 'dart:convert';

// import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as h_t_t_p;

// import 'package:razorpay_flutter/razorpay_flutter.dart';

//
import '../core.dart';

class PackageController extends GetxController {
  RootService rootService = Get.find();
  PackageService packageService = Get.find();
  // Razorpay razorpay = Razorpay();
  int page = 1;
  // late ConfettiController controllerCenter;
  bool isEventProcessed = false;
  late Future<void> debounceTimer;

  @override
  void onInit() {
    super.onInit();
    // controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
  }

  getPackagesAnFeatures() async {
    EasyLoading.show(status: "${"Loading".tr}..${"Please Wait".tr}");
    var response = await Helper.sendRequestToServer(endPoint: 'get-packages', requestData: {'data': ""});
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        PackageService.to.packages.value = Helper.parseItem(jsonData['packages'], Package.fromJson);
        PackageService.to.packages.refresh();
        PackageService.to.packageFeatures.value = Helper.parseItem(jsonData['features'], PackageFeature.fromJson);
        PackageService.to.packageFeatures.refresh();
      } else {
        Helper.showToast(msg: jsonData['msg']);
        // throw  Exception(response.body);
      }
    }
  }

  makePayment(double amount) {
    isEventProcessed = false;
    /*var options = {
      'key': 'rzp_test_eQrDSYDqE1pX1z',
      'amount': amount * 100,
      'name': '${PackageService.to.currentPackage.value.title}',
      'description': Helper.removeAllHtmlTags(PackageService.to.currentPackage.value.description ?? ""),
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': UserService.to.currentUser.value.phone, 'email': UserService.to.currentUser.value.email == "" ? 'test@razorpay.com' : UserService.to.currentUser.value.email},
      //   'external': {
      //     'wallets': ['paytm']
      //   }
      // };
    };*/
    /*razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);*/
  }

  /*void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    */ /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */ /*
    if (isEventProcessed) return; // Prevent further execution if already processed
    isEventProcessed = true; // Mark as processed

    // Debounce logic to prevent multiple quick calls
    debounceTimer = Future.delayed(const Duration(milliseconds: 300), () async {
      //print("Razorpay.PAYMENT_CANCELLED ${Razorpay.PAYMENT_CANCELLED}");
      if (Razorpay.PAYMENT_CANCELLED == 2) {
        showAlertDialog("Payment Cancelled by the user", "Code ${Razorpay.PAYMENT_CANCELLED}");
        return;
      }
      await buyPackage(showLoader: false, transactionId: "", paymentMethod: "RZP", packageId: PackageService.to.currentPackage.value.id.toString(), paymentStatus: "F", response: response.error);
      isEventProcessed = false;
      showAlertDialog("Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    });
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    //print("handlePaymentSuccessResponse");
    */ /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */ /*
    */ /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */ /*
    if (isEventProcessed) return; // Prevent further execution if already processed

    isEventProcessed = true; // Mark as processed

    // Debounce logic to prevent multiple quick calls
    debounceTimer = Future.delayed(const Duration(milliseconds: 300), () async {
      await buyPackage(
          showLoader: true, transactionId: response.paymentId!, paymentMethod: "RZP", packageId: PackageService.to.currentPackage.value.id.toString(), paymentStatus: "S", response: response.data);
      isEventProcessed = false;
      showAlertDialog("Payment Successful", "Payment ID: ${response.paymentId}");
      await Future.delayed(3000.ms);
      Get.backLegacy(closeOverlays: true);
      Get.offNamed(Routes.loadingPage);
    });
  }*/

  void showAlertDialog(String title, String message) {
    // set up the buttons
    /*Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );*/

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  buyPackage({
    bool showLoader = false,
    String packageId = "",
    String paymentStatus = "",
    String transactionId = "",
    String paymentMethod = "",
    Map? response,
  }) async {
    if (showLoader) EasyLoading.show(status: "${"Loading".tr}..${"Please Wait".tr}");
    var result = await Helper.sendRequestToServer(
      endPoint: 'buy-membership',
      requestData: {
        'membership_id': packageId,
        'status': paymentStatus,
        'payment_method': paymentMethod,
        'transaction_id': transactionId,
        'response': jsonEncode(response!),
      },
      method: "post",
    );
    EasyLoading.dismiss();
    if (result.statusCode == 200) {
      //print("getData dashboard response success");
      //print(result.body);
      var jsonData = json.decode(result.body);
      if (jsonData['status']) {
      } else {
        Helper.showToast(msg: jsonData['msg']);
        // throw  Exception(response.body);
      }
    }
  }

  Future<void> fetchMyMemberships() async {
    h_t_t_p.Response response = await Helper.sendRequestToServer(endPoint: "my-packages", method: "get", requestData: {"data_var": "data"});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        UserService userService = Get.find();
        userService.myMemberships.value = Helper.parseItem(jsonData['data'], UserMembership.fromJson);
        userService.myMemberships.refresh();
      }
    }
  }

  Future<void> applyCoupon() async {
    //print("applyCoupon");
    var response = await Helper.sendRequestToServer(
      endPoint: 'apply-coupon',
      requestData: {
        "coupon_code": packageService.couponCode.value,
      },
      method: "post",
    );

    var responseResult = json.decode(response.body);

    if (responseResult["status"]) {
      Helper.showToast(msg: "Coupon successfully applied");
      packageService.appliedCouponType = responseResult["discount_type"];
      packageService.appliedCouponValue.value = responseResult["amount"];
      packageService.appliedCouponValue.refresh();
      // return "Done";
    } else {
      Helper.showToast(type: "error", msg: responseResult["msg"], durationInSecs: 2);
      // return "Error";
    }
  }
}
