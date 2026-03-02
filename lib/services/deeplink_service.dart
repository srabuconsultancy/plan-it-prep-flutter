import 'dart:async';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import '../controllers/PaymentController.dart';
import '../routes/routes.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  StreamSubscription? _sub;
  late AppLinks _appLinks;
  bool _initialURIHandled = false;

  /// Initialize the deep link service
  /// Call this in main.dart after runApp
  Future<void> init() async {
    _appLinks = AppLinks();

    // Handle the initial URI when app is opened via deep link
    if (!_initialURIHandled) {
      _initialURIHandled = true;
      try {
        final initialURI = await _appLinks.getInitialAppLink();
        if (initialURI != null) {
          _handleDeepLink(initialURI);
        }
      } catch (e) {
        print('Failed to get initial URI: $e');
      }
    }

    // Handle incoming URIs when app is already running
    _sub = _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri);
    }, onError: (err) {
      print('Deep link error: $err');
    });
  }

  /// Handle the incoming deep link
  void _handleDeepLink(Uri uri) {
    print('Received deep link: $uri');

    // Extract path and query parameters
    final path = uri.path;
    final params = uri.queryParameters;

    print('Path: $path');
    print('Parameters: $params');

    if (uri.host == 'planit-prep-web.vercel.app' &&
        (path == '/payment' || path == '/payment/')) {
      unawaited(_verifyPaymentAndGoHome(params['session_id']));
      return;
    }

    Get.offAllNamed(Routes.home);
  }

  Future<void> _verifyPaymentAndGoHome(String? sessionId) async {
    try {
      final paymentController = Get.isRegistered<PaymentController>()
          ? Get.find<PaymentController>()
          : Get.put(PaymentController());
      await paymentController.verifyPayment(sessionId);
    } catch (e) {
      print('Payment verify deep link error: $e');
    } finally {
      Get.offAllNamed(Routes.home);
    }
  }

  /// Dispose the service
  void dispose() {
    _sub?.cancel();
  }
}
