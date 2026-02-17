import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as d_i_o;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as h_t_t_p;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core.dart';

class Helper {
  var minDate = DateTime.now().subtract(const Duration(days: 29200));
  var yearBefore = DateTime.now().subtract(const Duration(days: 4746));
  var dateFormatter = DateFormat('yyyy-MM-dd 00:00:00.000');
  var formatterYear = DateFormat('yyyy');
  var formatterDate = DateFormat('dd MMM yyyy');
  String minYear = "";
  String maxYear = "";
  String initDatetime = "";

  Helper() {
    minYear = formatterYear.format(minDate);
    maxYear = formatterYear.format(yearBefore);
    initDatetime = formatterDate.format(yearBefore);
  }

  static String getRandomString(int length, {bool numeric = false}) {
    String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    if (numeric) {
      chars = '1234567890789435045657822340';
    }
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  late BuildContext context;
  DateTime currentBackPressTime = DateTime.now();
  static bool isRtl = false;
  Helper.of(this.context);

  static getData(data) {
    return data!['data'] ?? [];
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int);
  }

  static bool getBoolData(Map<String, dynamic> data) {
    return (data['data'] as bool);
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? <String, dynamic>{};
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static String formatter(String currentBalance) {
    try {
      // suffix = {' ', 'k', 'M', 'B', 'T', 'P', 'E'};
      double value = double.parse(currentBalance);

      if (value < 0) {
        // less than a thousand
        return "0";
      } else if (value < 1000) {
        // less than a thousand
        return value.toStringAsFixed(0);
      } else if (value >= 1000 && value < (1000 * 100 * 10)) {
        // less than a million
        double result = value / 1000;
        return "${result.toStringAsFixed(1)}k";
      } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
        // less than 100 million
        double result = value / 1000000;
        return "${result.toStringAsFixed(1)}M";
      } else if (value >= (1000000 * 10 * 100) &&
          value < (1000000 * 10 * 100 * 100)) {
        // less than 100 billion
        double result = value / (1000000 * 10 * 100);
        return "${result.toStringAsFixed(1)}B";
      } else if (value >= (1000000 * 10 * 100 * 100) &&
          value < (1000000 * 10 * 100 * 100 * 100)) {
        // less than 100 trillion
        double result = value / (1000000 * 10 * 100 * 100);
        return "${result.toStringAsFixed(1)}T";
      } else {
        return "0";
      }
    } catch (e) {
      return "";
      // //print(e);
    }
  }

  static showLoaderSpinner(color) {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ${number.substring(4, 8)}';
      result += ' ${number.substring(8, 12)}';
      result += ' ${number.substring(12, 16)}';
    }
    return result;
  }

  static Uri getUri(String path) {
    String path0 = Uri.parse(baseUrl).path;
    if (!path0.endsWith('/')) {
      path0 += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(baseUrl).scheme,
        host: Uri.parse(baseUrl).host,
        port: Uri.parse(baseUrl).port,
        path: "${path0}api/v1/$path");

    return uri;
  }

  Color getColorFromHex(String hex) {
    if (hex.contains('#')) {
      return Color(int.parse(hex.replaceAll("#", "0xFF")));
    } else {
      return Color(int.parse("0xFF$hex"));
    }
  }

  static BoxFit getBoxFit(String boxFit) {
    switch (boxFit) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fit_height':
        return BoxFit.fitHeight;
      case 'fit_width':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      case 'scale_down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  static AlignmentDirectional getAlignmentDirectional(
      String alignmentDirectional) {
    switch (alignmentDirectional) {
      case 'top_start':
        return AlignmentDirectional.topStart;
      case 'top_center':
        return AlignmentDirectional.topCenter;
      case 'top_end':
        return AlignmentDirectional.topEnd;
      case 'center_start':
        return AlignmentDirectional.centerStart;
      case 'center':
        return AlignmentDirectional.topCenter;
      case 'center_end':
        return AlignmentDirectional.centerEnd;
      case 'bottom_start':
        return AlignmentDirectional.bottomStart;
      case 'bottom_center':
        return AlignmentDirectional.bottomCenter;
      case 'bottom_end':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.bottomEnd;
    }
  }

  static toast(String msg, Color color) {
    msg = removeTrailing("\n", msg);
    return SnackBar(
      duration: const Duration(seconds: 4),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  static OverlayEntry overlayLoader(context, [Color? color]) {
    // RootService mainService = Get.find();
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = Get.mediaQuery.size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color:
              color ?? Theme.of(context).primaryColor.withValues(alpha: 0.85),
          child: Helper.showLoaderSpinner(Get.theme.iconTheme.color!),
        ),
      );
    });
    return loader;
  }

  static showToast(
      {String msg = "", int durationInSecs = 2, String type = "info"}) {
    toastification.show(
      context: Get.context, // optional if you use ToastificationWrapper
      title: Text(msg.tr),
      type: type == "info"
          ? ToastificationType.info
          : type == "error"
              ? ToastificationType.error
              : type == "success"
                  ? ToastificationType.success
                  : ToastificationType.warning,
      autoCloseDuration: Duration(seconds: durationInSecs),
    );
  }

  static String removeTrailing(String pattern, String from) {
    int i = from.length;
    while (from.startsWith(pattern, i - pattern.length)) {
      i -= pattern.length;
    }
    return from.substring(0, i);
  }

  static fSafeChar(var data) {
    if (data == null) {
      return "";
    } else {
      return data;
    }
  }

  static fSafeNum(var data) {
    if (data == null) {
      return 0;
    } else {
      return data;
    }
  }

  static Future<bool> isIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.name.toLowerCase().contains("ipad")) {
      return true;
    }
    return false;
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Fluttertoast.showToast(msg: "Tap again to exit an app.");
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  static DateTime getYourCountryTime(DateTime datetime) {
    DateTime dateTime = DateTime.now();
    Duration timezone = dateTime.timeZoneOffset;
    return datetime.add(timezone);
  }

  imageLoaderWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Image.asset('assets/images/loading.gif', fit: BoxFit.fill),
      ),
    );
  }

  static Color? getColor(String colorCode) {
    colorCode = colorCode.replaceAll("#", "");

    try {
      if (colorCode.length == 6) {
        return Color(int.parse("0xFF$colorCode"));
      } else if (colorCode.length == 8) {
        return Color(int.parse("0x$colorCode"));
      } else {
        return const Color(0xFFCCCCCC).withValues(alpha: 1);
      }
    } catch (e) {
      //print("printColor error $e");
      return const Color(0xFFCCCCCC).withValues(alpha: 1);
    }
  }

  static List<int> parsePusherEventData(var data) {
    List<int> ids = [];
    if (Platform.isAndroid) {
      String tempData = data.replaceAll('[', '').replaceAll(']', '');
      List tempIds = tempData.split(',');
      if (tempIds.isNotEmpty) {
        for (var element in tempIds) {
          if (element.indexOf('User id=') > -1) {
            if (!ids.contains(
                int.parse(element.replaceAll("User id=", "").trim()))) {
              ids.add(int.parse(element.replaceAll("User id=", "").trim()));
            }
          }
        }
      }
    } else {
      var temp = jsonDecode(data);
      if (temp['presence']['ids'] != null) {
        String tempData = temp['presence']['ids']
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '');
        List tempIds = tempData.split(',');
        if (tempIds.isNotEmpty) {
          for (var element in tempIds) {
            if (!ids.contains(int.parse(element))) {
              ids.add(int.parse(element));
            }
          }
        }
      }
    }
    //print("IDSsss $ids");
    return ids;
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  static String getDurationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String timeAgoSinceDate(String dateString,
      {String dateFormat = "yyyy-MM-ddTHH:mm:ss", bool short = true}) {
    // if (kDebugMode) //print("dateString $dateString");
    //print("222222");
    //print(dateString);
    DateTime notificationDate = DateFormat(dateFormat).parse(dateString, true);

    notificationDate = notificationDate.toLocal();
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);
    // if (kDebugMode) //print("difference.inDays ${difference.inDays}");
    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()}${short ? "y" : " ${'year ago'.tr}"}";
    } else if (difference.inSeconds < 3) {
      return 'just now'.tr;
    } else if (difference.inSeconds < 60) {
      return "${difference.inSeconds}${short ? 's' : " ${'seconds ago'.tr}"}";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}${short ? "min" : " ${'min ago'.tr}"}";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}${short ? "h" : " ${'hour ago'.tr}"}";
    } else if (difference.inDays < 30) {
      return "${difference.inDays}${short ? "d" : " ${'day ago'.tr}"}";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()}${short ? "m" : " ${'month ago'.tr}"}";
    } else {
      return "";
    }
  }

  static Future sendRequestToServer(
      {required String endPoint,
      Map<String, dynamic> requestData = const {"foo": "bar"},
      Map<String, String> additionalHeaders = const {},
      String method = 'get',
      Function(int, int)? onSendProgress,
      List<UploadFile> files = const []}) async {
    bool connectionOn = returnFromApiIfInternetIsOff();
    if (!connectionOn) {
      //print("Internet is not working");
      return connectionOn;
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'USER': apiUser,
      'KEY': apiKey,
    };
    Uri uri = getUri(endPoint);
    //print("uri ${uri.toString()} ${Get.find<UserService>().currentUser.value.accessToken} $requestData $files");

    print('medthod received $method');

    if (additionalHeaders.isNotEmpty) {
      headers.addAll(additionalHeaders);
    }
    headers['Authorization'] =
        'Bearer ${Get.find<UserService>().currentUser.value.accessToken}';
    //print("ALL Headers $headers");
    if (files.isNotEmpty) {
      onSendProgress ??= (sent, total) {
        RootService.to.uploadProgress.value = sent / total;
        RootService.to.uploadProgress.refresh();
      };
      try {
        for (var element in files) {
          requestData[element.variableName] =
              await d_i_o.MultipartFile.fromFile(element.filePath,
                  filename: element.fileName);
        }

        d_i_o.FormData formData = d_i_o.FormData.fromMap(requestData);
        //print("uri ${uri.toString()} ${Get.find<UserService>().currentUser.value.accessToken} $requestData");
        var response = await d_i_o.Dio().post(
          uri.toString(),
          options: d_i_o.Options(
            headers: headers,
          ),
          data: formData,
          onSendProgress: onSendProgress,
        );
        dev.log("$endPoint POST REQ response.body ${response.data}");
        return response;
      } on d_i_o.DioException catch (e) {
        //print("Error While uploading the request $e $s");
        if (e.response != null) {
          dev.log(e.response!.data);
          //print(e.response!.headers);
          //print(e.response!.requestOptions);
        } else {
          //print(e.requestOptions);
          //print(e.message);
        }
        return {
          'status': false,
          'error': e.message
        }; // Return error details to avoid null
      }
    }

    if (method == "get") {
      Map<String, dynamic> data = Map<String, dynamic>.from(requestData as Map);
      uri = uri.replace(queryParameters: data);
    }

    h_t_t_p.Response response;

    if (method == "post") {
      try {
        response = await post(
          uri,
          headers: headers,
          body: jsonEncode(requestData),
        );
        dev.log("$endPoint POST REQ response.body ${response.body}");

        return response;
      } catch (e, s) {
        // <--- ADD 's' HERE

        // 1. Print the Error object (what went wrong)
        print("Error object: $e");

        // 2. Print the Stack Trace (where it went wrong)
        print("Stack Trace: $s");

        // Optional: Use dev.log for better formatting in Flutter DevTools
        dev.log("Error inside POST request", error: e, stackTrace: s);

        rethrow; // Optional: If you want the UI to know it failed
      }
    } else {
      try {
        response = await get(
          uri,
          headers: headers,
        );

        dev.log(response.body);
        return response;
      } catch (e) {
        //print("Error While get request $e $s");
      }
    }
  }

  static Future sendRequestToChatGPT(
      {required String endPoint,
      required Map<String, dynamic> requestData,
      Map<String, String> additionalHeaders = const {},
      String method = 'get',
      Function(int, int)? onSendProgress,
      List<UploadFile> files = const []}) async {
    bool connectionOn = returnFromApiIfInternetIsOff();
    if (!connectionOn) {
      //print("Internet is not working");
      return connectionOn;
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'USER': apiUser,
      'KEY': apiKey,
    };
    Uri uri = getUri(endPoint);
    //print("uri ${uri.toString()} ${Get.find<UserService>().currentUser.value.accessToken} $requestData $files");
    if (additionalHeaders.isNotEmpty) {
      headers.addAll(additionalHeaders);
    }
    headers['Authorization'] =
        'Bearer ${Get.find<UserService>().currentUser.value.accessToken}';
    //print("ALL Headers $headers");
    if (files.isNotEmpty) {
      try {
        for (var element in files) {
          requestData[element.variableName] =
              await d_i_o.MultipartFile.fromFile(element.filePath,
                  filename: element.fileName);
        }

        d_i_o.FormData formData = d_i_o.FormData.fromMap(requestData);
        //print("uri ${uri.toString()} ${Get.find<UserService>().currentUser.value.accessToken} $requestData");
        var response = await d_i_o.Dio().post(
          uri.toString(),
          options: d_i_o.Options(
            headers: headers,
          ),
          data: formData,
          onSendProgress: onSendProgress,
        );
        return response;
      } catch (e) {
        //print("Error While uploading the request $e $s");
      }
    }

    if (method == "get") {
      Map<String, dynamic> data = Map<String, dynamic>.from(requestData as Map);
      uri = uri.replace(queryParameters: data);
    }

    h_t_t_p.Response response;
    if (method == "post") {
      //print("POST REQ ENTERED");
      try {
        response = await post(
          uri,
          headers: headers,
          body: jsonEncode(requestData),
        );
        dev.log("POST REQ response.body ${response.body}");

        return response;
      } catch (e) {
        //print("Error While post request $e $s");
      }
    } else {
      try {
        response = await get(
          uri,
          headers: headers,
        );

        dev.log(response.body);
        return response;
      } catch (e) {
        //print("Error While get request $e $s");
      }
    }
  }

  static bool returnFromApiIfInternetIsOff() {
    RootService rootService = Get.find();
    if (!rootService.isInternetWorking.value &&
        !rootService.firstTimeLoad.value) {
      toastification.show(
        context: Get.context, // optional if you use ToastificationWrapper
        title: Text(
            'There is no network connection right now. please check your internet connection.'
                .tr),
        autoCloseDuration: const Duration(seconds: 4),
      );
      //print("returnFromApiIfInternetIsOff ENTERED");
      return false;
    } else {
      //print("returnFromApiIfInternetIsOff NOT ENTERED");
      return true;
    }
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static String timeAgoCustom(DateTime d) {
    // <-- Custom method Time Show  (Display Example  ==> 'Today 7:00 PM')     // WhatsApp Time Show Status Shimila
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "y" : "years".tr} ${'ago'.tr}";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "m" : "months".tr} ${'ago'.tr}";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "w" : "weeks".tr} ${'ago'.tr}";
    if (diff.inDays > 0) return DateFormat.E().add_jm().format(d);
    if (diff.inHours > 0) return "${'Today'.tr} ${DateFormat('jm').format(d)}";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "minutes".tr} ${'ago'.tr}";
    if (diff.inSeconds > 3 && diff.inSeconds < 60)
      return "${diff.inSeconds} ${diff.inSeconds == 1 ? "s" : "seconds".tr} ${'ago'.tr}";
    return "just now".tr;
  }

  static String convertToUnicode(String input) {
    // Convert each character to its Unicode equivalent
    return input.runes.map((int rune) {
      var char = String.fromCharCode(rune);
      if (rune > 127) {
        // Convert special character to Unicode if it is non-ASCII
        return '\\u${rune.toRadixString(16).padLeft(4, '0')}';
      }
      return char;
    }).join();
  }

  static String decodeUnicode(String input) {
    // Decode \uXXXX format
    String decoded =
        input.replaceAllMapped(RegExp(r'\\u([0-9a-fA-F]{4})'), (Match match) {
      return String.fromCharCode(int.parse(match.group(1)!, radix: 16));
    });

    // Decode surrogate pairs for emojis (e.g., \ud83e\udd73)
    decoded = decoded.replaceAllMapped(
        RegExp(r'\\u([0-9a-fA-F]{4})\\u([0-9a-fA-F]{4})'), (Match match) {
      int high = int.parse(match.group(1)!, radix: 16);
      int low = int.parse(match.group(2)!, radix: 16);
      return String.fromCharCode(high) + String.fromCharCode(low);
    });

    return decoded;
  }

  static isRTL() {
    isRtl = Directionality.of(Get.context!)
        .toString()
        .contains(TextDirection.RTL.value.toLowerCase());
  }

  static launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw '${"Could not launch".tr} $url';
    }
  }

  static Future<void> launchLinkedURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  static void dismissToast() {
    toastification.dismissAll();
  }

  static void closeOverlay() {
    Navigator.pop(Get.context!);
  }

  /*static parseItem(List<dynamic> items, Type dataType) {
    List list = items;
    List<dataType> attrList = list.map((data) => dataType.fromJSON(data)).toList();
    return attrList;
  }*/

  static List<T> parseItem<T>(
      List<dynamic> items, T Function(Map<String, dynamic>) fromJson) {
    //print("parseItem items ${items.length}");
    return items.map((item) {
      return fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  static String countryCodeToEmoji(String countryCode) {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  static convertQuantityString(MealPlanFoodItem foodItem, {String value = ""}) {
    String str = "";
    if (foodItem.servingUnit!.toLowerCase() == "cup") {
      if (value.contains(".00") || value.contains(".0")) {
        str = double.parse(value).toStringAsFixed(0);
      } else {
        str = double.parse(value).toStringAsFixed(1);
      }
    } else {
      str = double.parse(value).toStringAsFixed(1);
    }
    return str;
  }

  static List<double> generateDoubleList(
      {double start = 0.0, double end = 100.0, double interval = 1.0}) {
    List<double> doubleList = [];
    for (double i = start; i <= end; i += interval) {
      doubleList.add(i);
    }
    return doubleList;
  }

// couponType can be P percentage discount or F flat discount
  static double calculateDiscountedAmount() {
    PackageService packageService = Get.find();
    double amount = packageService.currentPackage.value.price! >
            packageService.currentPackage.value.discountedPrice!
        ? packageService.currentPackage.value.discountedPrice!
        : packageService.currentPackage.value.price!;
    double discount = double.parse(packageService.appliedCouponValue.value == ""
        ? "0"
        : packageService.appliedCouponValue.value);
    String couponType = packageService.appliedCouponType;
    double discountAmount = 0.0;
    if (couponType == "percent") {
      if (amount < 0 || discount < 0 || discount > 100) {
        throw ArgumentError(
            "Invalid input values. Ensure originalPrice is non-negative and discountPercentage is between 0 and 100.");
      }
      discountAmount = (amount * discount) / 100;
    } else {
      //print("calculateDiscountedAmount $discount");
      discountAmount = discount;
    }
    return amount - discountAmount;
  }

  static calculateDiscountAmount() {
    PackageService packageService = Get.find();
    double amount = packageService.currentPackage.value.price! >
            packageService.currentPackage.value.discountedPrice!
        ? packageService.currentPackage.value.discountedPrice!
        : packageService.currentPackage.value.price!;
    double discount = double.parse(packageService.appliedCouponValue.value == ""
        ? "0"
        : packageService.appliedCouponValue.value);
    String couponType = packageService.appliedCouponType;
    double discountAmount = 0.0;
    if (couponType == "percent") {
      if (amount < 0 || discount < 0 || discount > 100) {
        throw ArgumentError(
            "Invalid input values. Ensure originalPrice is non-negative and discountPercentage is between 0 and 100.");
      }
      discountAmount = (amount * discount) / 100;
    } else {
      //print("calculateDiscountAmount $discount");
      discountAmount = discount;
    }
    return discountAmount;
  }

  static String formatIfDecimal(num value, {int decimal = 2}) {
    // Check if the number has a decimal value
    if (value % 1 != 0) {
      // If it has a decimal value, return it as a string with two decimal places
      return value.toStringAsFixed(decimal);
    } else {
      // If it doesn't have a decimal value, return it as an integer (no decimals)
      return value.toStringAsFixed(0);
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
