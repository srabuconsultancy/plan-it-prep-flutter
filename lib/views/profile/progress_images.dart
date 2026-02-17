import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core.dart';

class ProgressImages extends StatelessWidget {
  const ProgressImages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    UserService userService = Get.find();
    return Scaffold(
      appBar: AppBarWidget(
        height: 80,
        onTap: () {
          Get.back();
        },
        title: "My Progress Images",
        actions: [
          OpenContainer(
            transitionType: ContainerTransitionType.fade,
            openBuilder: (BuildContext context, VoidCallback _) {
              return const ProgressImageUploader();
            },
            transitionDuration: const Duration(seconds: 2),
            closedElevation: 0.0,
            /*closedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),*/
            closedColor: Colors.transparent,
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return SvgPicture.asset(
                "assets/icons/shutter.svg",
                width: 25,
                height: 25,
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(glLightThemeColor.withValues(alpha: 0.9), BlendMode.srcIn),
              );
            },
          ).pOnly(left: 30),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Obx(
          () => userService.myProgressImages.value.isEmpty
              ? SizedBox(
                  height: Get.height * 0.8,
                  width: Get.width,
                  child: "No Progress Images uploaded.".text.make().centered(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    UserController userController = Get.find();
                    await userController.getMyProgressImages();
                  },
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Set the number of columns in the grid
                      crossAxisSpacing: 2, // Horizontal spacing between items
                      mainAxisSpacing: 2, // Vertical spacing between items
                      childAspectRatio: 0.8, // Aspect ratio of each item (height/width)
                    ),
                    itemCount: userService.myProgressImages.value.length,
                    itemBuilder: (context, index) {
                      final progress = userService.myProgressImages.value[index];
                      return ProgressCard(progressImage: progress);
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final ProgressImage progressImage;

  const ProgressCard({super.key, required this.progressImage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: glLightPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Creating the instant camera photo effect
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: glLightPrimaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: glDarkPrimaryColor.withValues(alpha: 0.1),
                  blurRadius: 2,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: progressImage.image,
                height: 180,
                width: double.infinity,
                memCacheHeight: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Label at the bottom center of the photo
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              DateFormat('yyyy-MM-dd').format(progressImage.uploadedAt.toLocal()),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
