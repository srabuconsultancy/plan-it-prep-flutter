import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class CouponWidget extends StatelessWidget {
  const CouponWidget({
    super.key,
    required this.item,
    this.onTap,
    this.isApply = false,
  });

  final CouponItem? item;
  final VoidCallback? onTap;
  final bool isApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 150,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: glLightIconColor.withValues(alpha: 0.1),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const FractionalOffset(0.0, 0.6),
                end: const FractionalOffset(0.5, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
                colors: <Color>[Get.theme.colorScheme.primary, Colors.pink],
              ),
            ),
            child: RotatedBox(
              quarterTurns: 3,
              child: (item!.discountType == 'flat'
                      ? '\$${item!.price} OFF'
                      : item!.discountType == 'percent'
                          ? '${item!.price} OFF'
                          : 'ONE BY ONE')
                  .text
                  .center
                  .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(
                    color: Get.theme.primaryColor,
                    fontSize: 20,
                  ))
                  .make()
                  .centered(),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item!.title.text
                          .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(
                            color: glLightIconColor,
                            fontSize: 18,
                          ))
                          .wide
                          .make()
                          .pOnly(bottom: 6),
                      isApply
                          ? GestureDetector(
                              onTap: onTap,
                              child: "Apply"
                                  .text
                                  .uppercase
                                  .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(
                                    color: Get.theme.colorScheme.primary,
                                    fontSize: 12,
                                  ))
                                  .make(),
                            )
                          : SizedBox()
                    ],
                  ),
                  (item!.discountType == 'flat'
                          ? 'Save \$${item!.price} on this order'
                          : item!.discountType == 'percent'
                              ? '${item!.price} OFF'
                              : 'ONE BY ONE')
                      .text
                      .center
                      .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(
                        color: Colors.green,
                        fontSize: 15,
                      ))
                      .make()
                      .pOnly(bottom: 10),
                  Divider(color: Get.theme.dividerColor.withValues(alpha: 0.8)).pOnly(bottom: 5),
                  RichText(
                    text: TextSpan(
                      text: "Use code ",
                      style: TextStyle(fontWeight: FontWeight.normal, color: glLightIconColor.withValues(alpha: 0.7), fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                          text: item!.code,
                          style: TextStyle(fontWeight: FontWeight.bold, color: glLightIconColor.withValues(alpha: 0.7), fontSize: 16),
                        ),
                        TextSpan(
                          text: ' & get \$${item!.price} off on orders.',
                          style: TextStyle(fontWeight: FontWeight.normal, color: glLightIconColor.withValues(alpha: 0.7), fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  // item!.description.isNotEmpty
                  //     ? ReadMoreText(
                  //         item!.description,
                  //         trimLines: 2,
                  //         colorClickableText: Get.theme.colorScheme.primary,
                  //         trimMode: TrimMode.Line,
                  //         style: TextStyle(color: glLightIconColor, fontSize: 14),
                  //         trimCollapsedText: "more",
                  //         trimExpandedText: "less",
                  //         moreStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Get.theme.colorScheme.primary),
                  //         lessStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Get.theme.colorScheme.primary),
                  //       ).pSymmetric(h: 15, v: 10)
                  //     : SizedBox().pOnly(bottom: 15),
                ],
              ),
            ).pSymmetric(h: 15, v: 12),
          ),
        ],
      ),
    );
  }
}
