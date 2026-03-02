import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core.dart';

class UserProfile extends GetView<PackageController> {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();
    UserService authService = Get.find();

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FA), // Light grey/blue tint background
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Get.offNamed('/dashboard');
          }
        },
        child: Obx(
          () => SizedBox(
            height: Get.height,
            width: Get.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildProfileHeader(authController, authService),
                  const SizedBox(height: 20),
                  // _buildStatsBar(authService),
                  const SizedBox(height: 25),
                  _buildMenuOptions(context, authController),
                  // --- FIX 2: Increased bottom padding to clear BottomNavBar ---
                  const SizedBox(height: 120),
                  // -----------------------------------------------------------
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      UserController authController, UserService authService) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: glLightThemeColor.withOpacity(0.2), width: 4),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFDFF0E8),
                  child: ClipOval(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: UserService.to.currentUser.value.userDP.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: UserService.to.currentUser.value.userDP,
                              placeholder: (context, url) =>
                                  Lottie.asset('assets/lottie/loader.json'),
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/logo.jpg",
                                  fit: BoxFit.cover),
                            )
                          : Image.asset("assets/images/logo.jpg",
                              width: 40, height: 40),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => authController.showImagePickerBottomSheet(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: glShadeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(TablerIcons.camera,
                        size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                authService.currentUser.value.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: glShadeColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => Get.toNamed(Routes.editProfile),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(TablerIcons.pencil,
                      size: 18, color: glShadeColor.withOpacity(0.5)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          if (authService.currentUser.value.email.isNotEmpty)
            Text(
              authService.currentUser.value.email,
              style: TextStyle(
                  fontSize: 14,
                  color: glShadeColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500),
            ),
          if (authService.currentUser.value.phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              authService.currentUser.value.phone,
              style: TextStyle(
                  fontSize: 14,
                  color: glShadeColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }

  // Widget _buildStatsBar(UserService authService) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 15,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     // child: IntrinsicHeight(
  //     //   child: Row(
  //     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     //     children: [
  //     //       if (authService.currentUser.value.height > 0)
  //     //         _buildStatItem(
  //     //           'Height',
  //     //           '${authService.currentUser.value.height}',
  //     //           'CM',
  //     //           TablerIcons.ruler_2,
  //     //         ),
  //     //       if (authService.currentUser.value.height > 0 && DashboardService.to.data.value.currentWeight > 0)
  //     //         VerticalDivider(color: Colors.grey.withOpacity(0.2), thickness: 1),
  //     //       if (DashboardService.to.data.value.currentWeight > 0)
  //     //         _buildStatItem(
  //     //           'Weight',
  //     //           '${DashboardService.to.data.value.currentWeight}',
  //     //           'KG',
  //     //           TablerIcons.scale,
  //     //         ),
  //     //       if (DashboardService.to.data.value.currentWeight > 0 && DashboardService.to.data.value.targetWeight > 0)
  //     //         VerticalDivider(color: Colors.grey.withOpacity(0.2), thickness: 1),
  //     //       if (DashboardService.to.data.value.targetWeight > 0)
  //     //         _buildStatItem(
  //     //           'Target',
  //     //           '${DashboardService.to.data.value.targetWeight}',
  //     //           'KG',
  //     //           TablerIcons.target,
  //     //           isTarget: true,
  //     //         ),
  //     //     ],
  //     //   ),
  //     // ),
  //   ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms).fadeIn();
  // }

  Widget _buildStatItem(String label, String value, String unit, IconData icon,
      {bool isTarget = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: isTarget ? glLightThemeColor : glShadeColor,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: glShadeColor.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 12, color: glShadeColor.withOpacity(0.4)),
            const SizedBox(width: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
                color: glShadeColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuOptions(
      BuildContext context, UserController authController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              "ACCOUNT SETTINGS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: glShadeColor.withOpacity(0.5),
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                // --- Update Eating Preferences ---
                _buildListTile(
                  icon: TablerIcons.adjustments_horizontal,
                  title: "Update Eating Preferences",
                  onTap: () {
                    authController.registerProcessPageIndex.value = 0;
                    Get.toNamed(Routes.register);
                  },
                ),
                _buildDivider(),

                if (RootService.to.isFeatureAccessible &&
                    RootService.to.config.value.showPaymentsMemberships) ...[
                  _buildListTile(
                    icon: TablerIcons.receipt,
                    title: "Payment History",
                    onTap: () async {
                      UserController userController = Get.find();
                      await userController.getMyPayments();
                      Get.toNamed(Routes.paymentHistory);
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: TablerIcons.id_badge_2,
                    title: "My Memberships",
                    onTap: () async {
                      PackageController packageController = Get.find();
                      packageController.page = 1;
                      await packageController.fetchMyMemberships();
                      Get.toNamed(Routes.membershipList);
                    },
                  ),
                  _buildDivider(),
                ],

                _buildListTile(
                  icon: TablerIcons.bell,
                  title: "Notifications",
                  onTap: () => Get.toNamed(Routes.notifications),
                ),
                _buildDivider(),

                // --- Contact Us ---
                _buildListTile(
                  icon: TablerIcons.headset,
                  title: "Contact Us",
                  onTap: () => _showContactUsSheet(context),
                ),
                _buildDivider(),

                _buildListTile(
                  icon: TablerIcons.info_circle,
                  title: "About",
                  onTap: () => Get.toNamed('/about'),
                ),

                _buildListTile(
                  icon: TablerIcons.receipt,
                  title: "Subscription",
                  onTap: () async {
                    Get.toNamed(Routes.stripePayment);
                  },
                ),

                _buildListTile(
                  icon: TablerIcons.receipt,
                  title: "Payment History",
                  onTap: () async {
                    Get.toNamed(Routes.stripePaymentHistory);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              "DANGER ZONE",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent.withOpacity(0.7),
                letterSpacing: 1.2,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                _buildListTile(
                  icon: TablerIcons.trash,
                  title: "Delete Profile",
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                  onTap: () => authController.initDeleteProfilePopup(),
                ),
                _buildDivider(),
                _buildListTile(
                  icon: TablerIcons.logout,
                  title: "Logout",
                  iconColor: glShadeColor,
                  onTap: () => authController.logoutConfirmation(),
                ),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
    );
  }

  // --- CONTACT US BOTTOM SHEET LOGIC ---
  void _showContactUsSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Contact Support",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: glShadeColor,
                  ),
                ),
                // --- FIX: Use GestureDetector + Navigator.pop for reliability ---
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(TablerIcons.x,
                        size: 20, color: glShadeColor.withOpacity(0.7)),
                  ),
                ),
                // --------------------------------------------------------------------
              ],
            ),
            const SizedBox(height: 25),

            // Email Item
            _buildContactItem(
                icon: TablerIcons.mail,
                title: "Email Support",
                detail: "support@nutriai.com"),

            const SizedBox(height: 15),

            // Phone Item
            _buildContactItem(
                icon: TablerIcons.phone,
                title: "Call Us",
                detail: "+1 (555) 123-4567"),

            const SizedBox(height: 30),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildContactItem(
      {required IconData icon, required String title, required String detail}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: glLightThemeColor, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: glShadeColor.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 16,
                    color: glShadeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(TablerIcons.copy, size: 18, color: glShadeColor.withOpacity(0.3))
              .onInkTap(() {
            Clipboard.setData(ClipboardData(text: detail));
            Get.snackbar(
              "Copied",
              "$title copied to clipboard",
              snackPosition: SnackPosition.bottom,
              backgroundColor: glShadeColor.withOpacity(0.9),
              colorText: Colors.white,
              margin: const EdgeInsets.all(20),
              duration: const Duration(seconds: 2),
            );
          }),
        ],
      ),
    );
  }
  // ------------------------------------

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? glShadeColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor ?? glShadeColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? glShadeColor,
                  ),
                ),
              ),
              Icon(
                TablerIcons.chevron_right,
                size: 18,
                color: glShadeColor.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.05),
      indent: 60,
    );
  }
}
