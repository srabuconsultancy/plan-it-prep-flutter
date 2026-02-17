import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class FoodList extends GetView<MealPlanController> {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 50.0,
                  floating: false,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    background: Container(
                      height: 70,
                      color: Colors.white,
                      child: AppBarWidget(
                        title: "Add food${MealPlanService.to.selectedMealName.value != "" ? " to ${MealPlanService.to.selectedMealName.value}" : ""}",
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: 70.0,
                    maxHeight: 70.0,
                    child: PreferredSize(
                      preferredSize: const Size.fromHeight(70.0),
                      child: Container(
                        height: 70,
                        color: Colors.white,
                        child: CustomFormField(
                          // textFieldBgColor: Colors.black,
                          textFieldHeight: 70,
                          textFieldKey: controller.searchFieldKey,
                          textFieldOnChanged: controller.onSearchChanged,
                          textFieldHintText: "",
                          textFieldLabelText: "Search Food",
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Obx(
              () => NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  if (scrollEnd.metrics.atEdge) {
                    bool isTop = scrollEnd.metrics.pixels == 0;
                    if (isTop) {
                      return false;
                    }
                    controller.getFoodItems();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: MealPlanService.to.foodItems.length,
                  itemBuilder: (context, index) {
                    MealPlanFoodItem foodItem = MealPlanService.to.foodItems.elementAt(index);
                    return FoodItemWidget(
                      foodItem: foodItem,
                      showAddButton: true,
                      onAddButtonTap: () {
                        controller.openFoodItemDetailPopup(foodItem);
                      },
                      // onLike: () {},
                    )
                        /*.animate()
                        .fadeIn(
                          duration: 150.ms,
                          delay: (30.ms + (index * 3).ms),
                        )
                        .slideX(
                          duration: 150.ms,
                          delay: (30.ms + (index * 3).ms),
                        )*/
                        .pOnly(bottom: 8, top: 8, right: 15, left: 10);
                  },
                ),
              ),
            ),
          ),
          /*CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                // pinned: true,
                // snap: false,
                // floating: false,
                collapsedHeight: 60,
                toolbarHeight: 60,
                expandedHeight: 100,
                foregroundColor: Get.theme.highlightColor,
                backgroundColor: Colors.transparent,
                */ /*title: AppBarWidget(
                  title: "Add food",
                  onTap: () {
                    Get.back();
                  },
                ),*/ /*
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  background: AppBarWidget(
                    title: "Add food",
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: CustomFormField(
                    // textFieldBgColor: Colors.black,
                    textFieldHeight: 50,
                    textFieldKey: controller.searchFieldKey,
                    textFieldOnChanged: controller.onSearchChanged,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    */ /*Container(
                      width: Get.width,
                      height: Get.height,
                      color: Colors.red,
                    ),*/ /*
                    ...MealPlanService.to.foodItems.mapIndexed(
                      (MealPlanFoodItem foodItem, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: foodItem.image!,
                              imageBuilder: (context, imageProvider) => Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              //placeholder: (context, url) => EasyLoading.show(),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              placeholder: (context, url) => Center(
                                child: Lottie.asset(
                                  'assets/lottie/loader.json',
                                  height: 100,
                                ).paddingAll(10),
                              ),
                              errorWidget: (context, url, error) => SvgPicture.asset(
                                'assets/icons/diet-bowl.svg',
                                width: 22,
                                colorFilter: ColorFilter.mode(
                                  glLightThemeColor,
                                  BlendMode.srcIn,
                                ),
                              ).p(20),
                            ).cornerRadius(15).pOnly(right: 15),
                            // Text column
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(foodItem.name!, style: Get.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)).pOnly(bottom: 5),
                                  "${foodItem.servingSize}${foodItem.servingUnit} | ${foodItem.calories}${foodItem.calorieUnit ?? 'Kcal'}"
                                      .text
                                      .textStyle(Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300))
                                      .make()
                                      .pOnly(bottom: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: glLightDividerColor.withValues(alpha:0.2),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        // child: "P:${foodItem.proteinQty}${foodItem.proteinUnit}"
                                        child: "P:${foodItem.protein}"
                                            .text
                                            .textStyle(Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300, color: glLightDividerColor.withValues(alpha:0.8)))
                                            .make()
                                            .pSymmetric(h: 5, v: 3),
                                      ).pOnly(right: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: glLightDividerColor.withValues(alpha:0.2),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: "C:${foodItem.totalCarbohydrates}"
                                            .text
                                            .textStyle(Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300, color: glLightDividerColor.withValues(alpha:0.8)))
                                            .make()
                                            .pSymmetric(h: 5, v: 3),
                                      ).pOnly(right: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: glLightDividerColor.withValues(alpha:0.2),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: "F:${foodItem.totalFat}"
                                            .text
                                            .textStyle(Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300, color: glLightDividerColor.withValues(alpha:0.8)))
                                            .make()
                                            .pSymmetric(h: 5, v: 3),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Trailing icon
                            SvgPicture.asset(
                              "assets/icons/non-veg.svg",
                              height: 24,
                            ),
                          ],
                        )
                            */ /*.animate()
                            .slideX(
                              duration: 50.ms,
                              delay: (100.ms + (index * 33).ms),
                            )*/ /*
                            .pOnly(bottom: 8, top: 8, right: 15);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),*/
        ),
      ),
    );
  }
}
