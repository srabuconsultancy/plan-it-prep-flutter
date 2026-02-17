import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class ProgressImageUploader extends StatefulWidget {
  const ProgressImageUploader({super.key});

  @override
  State<ProgressImageUploader> createState() => _ProgressImageUploaderState();
}

class _ProgressImageUploaderState extends State<ProgressImageUploader> {
  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default pop
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && userController.showUploadProgressImageBackIcon.value) {
          userController.progressImage.value = File('');
          Get.backLegacy(closeOverlays: true);
        }
      },
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: const Text(''),
            automaticallyImplyLeading: false,
            leading: userController.showUploadProgressImageBackIcon.value
                ? Icon(Icons.arrow_back_ios).onInkTap(() {
                    userController.progressImage.value = File("");
                    Get.backLegacy(closeOverlays: true);
                  })
                : null,
          ),
          body: Obx(
            () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  'Upload Progress Image'.text.size(25).make().paddingOnly(bottom: 20),
                  if (userController.progressImage.value.path != "")
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: Get.width / 4,
                            backgroundImage: FileImage(userController.progressImage.value), // Replace with your image
                          ),
                          SizedBox(
                            width: Get.width / 2,
                            height: Get.width / 2,
                            child: CircularProgressIndicator(
                              strokeWidth: 10,
                              value: RootService.to.uploadProgress.value,
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(glLightThemeColor),
                            ),
                          ),
                          if (RootService.to.uploadProgress.value < 1.0)
                            Text(
                              '${(RootService.to.uploadProgress.value * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: glLightPrimaryColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (userController.progressImage.value.path == "")
                    IconButton(
                      icon: Icon(
                        Icons.camera_outlined,
                        size: Get.width / 1.8,
                        color: glLightThemeColor,
                      ),
                      onPressed: userController.pickProgressImage,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
