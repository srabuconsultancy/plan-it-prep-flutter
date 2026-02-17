import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';

import '../../../core.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();
    final user = UserService.to.currentUser.value;
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: glLightThemeColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: glAccentColor.withValues(alpha: 0.03),
            blurRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipOval(
                      child: user.userDP.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: user.userDP,
                              placeholder: (context, url) => Center(
                                child: Lottie.asset(
                                  'assets/lottie/loader.json',
                                  height: 120,
                                ).paddingAll(10),
                              ),
                              fit: BoxFit.fill,
                              errorWidget: (a, b, c) => Image.asset(
                                "assets/images/logo.jpg",
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              "assets/images/logo.jpg",
                              width: 30,
                              height: 30,
                            ),
                    ),
                  ),
                  Positioned(
                    right: 3,
                    top: 3,
                    child: CircleAvatar(
                      radius: 12.5,
                      backgroundColor: glAccentColor.withValues(alpha: 0.7),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          authController.showImagePickerBottomSheet();
                        },
                        icon: Icon(
                          TablerIcons.photo_edit,
                          size: 12,
                          color: glLightPrimaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ).paddingOnly(right: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  user.name.text
                      .textStyle(
                        Get.textTheme.headlineSmall!.copyWith(
                          color: glAccentColor,
                          fontSize: 18,
                        ),
                      )
                      .make()
                      .paddingOnly(bottom: 3),
                  if (user.phone.isNotEmpty)
                    "Mobile: ${user.phone}"
                        .text
                        .textStyle(
                          Get.textTheme.headlineSmall!.copyWith(
                            color: glAccentColor.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        )
                        .make()
                        .paddingOnly(bottom: 6),
                  if (user.email.isNotEmpty)
                    user.email.text
                        .textStyle(
                          Get.textTheme.headlineSmall!.copyWith(
                            color: glAccentColor.withValues(alpha: 0.8),
                            fontSize: 10,
                          ),
                        )
                        .make(),
                  if (user.height > 0) buildInfoRow("Height: ", "${user.height} CM"),
                  if (user.weight > 0) buildInfoRow("Weight: ", "${DashboardService.to.data.value.currentWeight} KG"),
                  if (DashboardService.to.data.value.targetWeight > 0) buildInfoRow("Target Weight: ", "${DashboardService.to.data.value.targetWeight} KG"),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 20, vertical: 20),
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: () => Get.toNamed(Routes.editProfile),
              child: Icon(TablerIcons.edit, size: 25, color: glAccentColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      children: [
        label.text
            .textStyle(
              Get.textTheme.bodySmall!.copyWith(
                color: glAccentColor.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            )
            .make(),
        value.text
            .textStyle(
              Get.textTheme.bodySmall!.copyWith(
                color: glAccentColor.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            )
            .make(),
      ],
    );
  }
}
