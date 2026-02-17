// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:nutri_ai/controllers/surprise_meal.controller.dart';
// import 'package:nutri_ai/core.dart';
// // We need SvgPicture, so ensure 'flutter_svg/flutter_svg.dart' is in core.dart or import it here


// // 1. Changed to GetView<SurpriseMealController>
// class SurpriseMealPage extends GetView<SurpriseMealController> {
//   const SurpriseMealPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 2. Put and find the new SurpriseMealController
//     Get.put(SurpriseMealController());

//     // Access theme colors
//     final Color primaryColor = glLightThemeColor;
//     final Color primaryTextColor = glDarkPrimaryColor;
//     final Color secondaryTextColor = Colors.grey[600] ?? Colors.grey;
//     final Color cardBackgroundColor = glLightPrimaryColor;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         // Use a standard AppBar for navigation
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: glDarkPrimaryColor),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           "Your Surprise Meal",
//           style: TextStyle(
//             color: glDarkPrimaryColor,
//             fontWeight: FontWeight.w700,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         // 3. Wrapped body in Obx to react to controller state
//         child: Obx(
//           () {
//             // 4. Show a loading indicator while fetching
//             if (controller.isLoading.value) {
//               return Center(
//                 child: Lottie.asset(
//                   'assets/lottie/loader.json', // Using your app's Lottie loader
//                   height: 120,
//                 ).paddingAll(10),
//               );
//             }

//             // 5. Show a message if no meals are found
//             if (controller.recipeCards.isEmpty) {
//               // --- MODIFIED: checks recipeCards ---
//               return Center(
//                 child: Text(
//                   "No surprise meals found.\nPlease try again later.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 16,
//                   ),
//                 ),
//               );
//             }

//             // 6. Show the list of meals
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: Get.width * 0.05,
//                   ),

//                   // --- MODIFIED: Use ListView.separated and _buildMealCard ---
//                   ListView.separated(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: controller.recipeCards.length,
//                     itemBuilder: (context, index) {
//                       final cardData = controller.recipeCards[index];
//                       // Use Obx here to listen for expansion changes
//                       return Obx(() {
//                         bool isExpanded =
//                             controller.expansionState[cardData.uniqueKey] ??
//                                 false;
//                         return _buildMealCard(
//                           cardData: cardData,
//                           isExpanded: isExpanded,
//                           onExpandTap: () => controller
//                               .toggleCardExpansion(cardData.uniqueKey),
//                           primaryColor: primaryColor,
//                           primaryTextColor: primaryTextColor,
//                           secondaryTextColor: secondaryTextColor,
//                           cardBackgroundColor: cardBackgroundColor,
//                         )
//                             .animate()
//                             .fadeIn(duration: 300.ms, delay: (50 * index).ms)
//                             .slideX(begin: 0.1);
//                       });
//                     },
//                     separatorBuilder: (context, index) =>
//                         const SizedBox(height: 15),
//                   ),
//                   // ------------------------------------

//                   SizedBox(
//                     height: Get.width * 0.1,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // --- NEW: Copied from CalendarPage ---
//   Widget _buildMealCard({
//     required RecipeCardData cardData, // <-- Using RecipeCardData from controller
//     required bool isExpanded,
//     required VoidCallback onExpandTap,
//     required Color primaryColor, // This is glLightThemeColor
//     required Color primaryTextColor,
//     required Color secondaryTextColor,
//     required Color cardBackgroundColor,
//   }) {
//     String vegNonVegIconAsset = cardData.isVegetarian
//         ? "assets/icons/veg.svg"
//         : "assets/icons/non-veg.svg";

//     return Card(
//       elevation: 2,
//       shadowColor: Colors.black.withOpacity(0.06),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(glBorderRadius - 2)),
//       color: cardBackgroundColor,
//       margin: const EdgeInsets.symmetric(horizontal: 15.0),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --- Top Row ---
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(vegNonVegIconAsset, width: 20, height: 20),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     cardData.recipeName,
//                     style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         color: primaryColor),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   cardData.day, // This will now show "Breakfast", "Lunch", etc.
//                   style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             // --- Bottom Row (Prep/Calories) ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildInfoColumn(
//                   icon: Icons.timer_outlined,
//                   label: "Preparation Time",
//                   value: cardData.prepTime,
//                   primaryTextColor: primaryTextColor,
//                   secondaryTextColor: secondaryTextColor,
//                 ),
//                 _buildInfoColumn(
//                   icon: Icons.whatshot_outlined,
//                   label: "Calories",
//                   value: cardData.calories,
//                   primaryTextColor: primaryTextColor,
//                   secondaryTextColor: secondaryTextColor,
//                 ),
//               ],
//             ),

//             // --- Divider ---
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Divider(color: Colors.grey.withOpacity(0.15), height: 1),
//             ),

//             // --- Expand Button Row ---
//             InkWell(
//               onTap: onExpandTap,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       isExpanded ? "Hide Recipe".tr : "Show Recipe".tr,
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: glLightButtonBGColor,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Icon(
//                       isExpanded ? Icons.expand_less : Icons.expand_more,
//                       color: glLightButtonBGColor,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // --- Expandable Section ---
//             AnimatedCrossFade(
//               firstChild: Container(height: 0),
//               secondChild: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 10.0, left: 4.0, right: 4.0, bottom: 4.0),
//                 child: Text(
//                   cardData.recipePoints,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: primaryTextColor.withOpacity(0.7),
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//               crossFadeState: isExpanded
//                   ? CrossFadeState.showSecond
//                   : CrossFadeState.showFirst,
//               duration: const Duration(milliseconds: 300),
//               firstCurve: Curves.easeOut,
//               secondCurve: Curves.easeIn,
//               sizeCurve: Curves.easeInOut,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- NEW: Copied from CalendarPage ---
//   Widget _buildInfoColumn({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color primaryTextColor,
//     required Color secondaryTextColor,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label.tr,
//           style: TextStyle(
//             fontSize: 11,
//             color: secondaryTextColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 3),
//         Row(
//           children: [
//             Icon(icon, color: primaryTextColor.withOpacity(0.8), size: 16),
//             const SizedBox(width: 5),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: primaryTextColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }