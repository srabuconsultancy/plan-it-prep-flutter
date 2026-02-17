// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../core.dart';

// /*class DetailedGraph extends GetView<DashboardController> {
//   const DetailedGraph({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => SafeArea(
//         child: Scaffold(
//           appBar: AppBarWidget(
//             height: 60,
//             title: "Detailed Analytics",
//             onTap: () {
//               //print("RootService.to.isOnHomePage.value");
//               //print(RootService.to.isOnHomePage.value);
//               if (!RootService.to.isOnHomePage.value) {
//                 RootService.to.isOnHomePage.value = true;
//                 DashboardService.to.currentPage.value = 0;
//                 DashboardService.to.currentPage.refresh();
//                 if (!controller.showHomeLoader.value) {
//                   DashboardService.to.pageController.value.animateToPage(DashboardService.to.currentPage.value, duration: const Duration(milliseconds: 100), curve: Curves.linear);
//                   DashboardService.to.pageController.refresh();
//                 }
//               }
//             },
//           ),
//           body: SafeArea(
//             child: ListView(
//               children: [
//                 SizedBox(
//                   height: Get.width * 0.05,
//                 ),
//                 SizedBox(
//                   height: 80,
//                   child: InkWell(
//                     onTap: () => controller.showDateRangePicker(),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Obx(
//                         () => Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             */ /*const Text(
//                               'Select Date Range',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 10),*/ /*
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       const Text(
//                                         'Start Date',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 10,
//                                           horizontal: 30,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(color: Colors.grey),
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         child: Text(
//                                           DashboardService.to.graphMacrosStartDate.value != null ? DashboardService.to.graphMacrosStartDate.value.toString() : 'Select Start Date',
//                                           style: TextStyle(
//                                             color: DashboardService.to.graphMacrosStartDate.value != null ? Colors.black : Colors.grey,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       const Text(
//                                         'End Date',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 10,
//                                           horizontal: 30,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(color: Colors.grey),
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         child: Text(
//                                           DashboardService.to.graphMacrosEndDate.value != null ? DashboardService.to.graphMacrosEndDate.value.toString() : 'Select End Date',
//                                           style: TextStyle(
//                                             color: DashboardService.to.graphMacrosEndDate.value != null ? Colors.black : Colors.grey,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: Get.width * 0.05,
//                 ),
//                 SizedBox(
//                   height: 100,
//                   child: Wrap(
//                     alignment: WrapAlignment.center,
//                     children: List.generate(
//                       6,
//                       (index) {
//                         //print("DashboardService.to.graphMacrosConsumed.value ${DashboardService.to.graphMacrosConsumed.value}");
//                         var macros = DashboardService.to.graphMacrosConsumed.value.first.toJson().keys;
//                         return Container(
//                           padding: const EdgeInsets.only(left: 10),
//                           width: Get.width / 3,
//                           height: 40,
//                           child: CheckboxMenuButton(
//                             value: controller.isGraphChecked[index],
//                             onChanged: (value) {
//                               controller.isGraphChecked[index] = value!;
//                               controller.isGraphChecked.refresh();
//                             },
//                             child: Text(macros.elementAt(index).capitalized),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         RoundContainer(
//                           size: 10,
//                           bgColor: Colors.black,
//                         ).paddingOnly(right: 5),
//                         "Daily Required Values".text.size(9).minFontSize(9).make(),
//                       ],
//                     ),
//                   ],
//                 ).pSymmetric(v: 10, h: 10),
//                 SizedBox(
//                   height: Get.width * 0.05,
//                 ),
//                 SizedBox(
//                   height: Get.width * 0.8 * (controller.isGraphChecked.where((element) => element == true).length),
//                   child: ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: 6,
//                     itemBuilder: (context, index) {
//                       //print("Get.width * (controller.isGraphChecked.where((element) => element == true).length) ${Get.width * (controller.isGraphChecked.where((element) => element == true).length)}");
//                       if (controller.isGraphChecked[index]) {
//                         return Container(
//                           padding: const EdgeInsets.only(left: 0, right: 10),
//                           height: Get.width * 0.8,
//                           width: double.maxFinite,
//                           child: Obx(
//                             () {
//                               List<String> bottomPoints = DashboardService.to.graphMacrosConsumed.value.map((e) => e.date).toList();
//                               List<double> stats = DashboardService.to.graphMacrosConsumed.value.map((e) {
//                                 switch (index) {
//                                   case 0:
//                                     return e.calories.toDouble();
//                                   case 1:
//                                     return e.carb.toDouble();
//                                   case 2:
//                                     return e.protein.toDouble();
//                                   case 3:
//                                     return e.fat.toDouble();
//                                   case 4:
//                                     return e.fiber.toDouble();
//                                   case 5:
//                                     return e.water.toDouble();
//                                   default:
//                                     throw Exception("Invalid index");
//                                 }
//                               }).toList();
//                               for (var element in DashboardService.to.graphMacrosConsumed.value) {
//                                 //print("graphMacrosConsumed element ${element.calories}");
//                               }
//                               double toAdd = 0;
//                               double dailyMacroValue = 0;
//                               String macroName = "";
//                               double interval = 10;
//                               Color macroLineColor = Colors.black;
//                               switch (index) {
//                                 case 0:
//                                   toAdd = 100;
//                                   macroName = "calories";
//                                   dailyMacroValue = UserService.to.currentUser.value.dailyCalorieIntake;
//                                   interval = 100;
//                                   macroLineColor = glCaloriesColor;
//                                 case 1:
//                                   toAdd = 10;
//                                   macroName = "carb";
//                                   dailyMacroValue = UserService.to.currentUser.value.dailyCarbIntake;
//                                   interval = 10;
//                                   macroLineColor = glCarbColor;
//                                 case 2:
//                                   toAdd = 10;
//                                   macroName = "protein";
//                                   dailyMacroValue = UserService.to.currentUser.value.dailyProteinIntake;
//                                   interval = 10;
//                                   macroLineColor = glProteinColor;
//                                 case 3:
//                                   toAdd = 10;
//                                   macroName = "fat";
//                                   dailyMacroValue = UserService.to.currentUser.value.dailyFatsIntake;
//                                   interval = 10;
//                                   macroLineColor = glFatColor;
//                                 case 4:
//                                   toAdd = 5;
//                                   macroName = "fiber";
//                                   dailyMacroValue = UserService.to.currentUser.value.dailyFiberIntake;
//                                   interval = 10;
//                                   macroLineColor = glFiberColor;
//                                 case 5:
//                                   toAdd = 1;
//                                   macroName = "water";
//                                   dailyMacroValue = UserService.to.currentUser.value.dailyWater;
//                                   interval = 0.5;
//                                   macroLineColor = glWaterColor;
//                                 default:
//                                   throw Exception("Invalid index");
//                               }
//                               double minVal = 0;
//                               double maxVal = (stats.max() == 0 ? dailyMacroValue : (stats.max() ?? 0)) + toAdd;
//                               //print("$macroName graphMacrosConsumed.max() $stats ${stats.max()} $maxVal");

//                               List<double> leftPoints = Helper.generateDoubleList(start: minVal, end: maxVal, interval: index == 0 ? 50 : 1);
//                               // //print("Length ${DashboardService.to.weightTrackingData.value.length} bottomPoints: $bottomPoints leftPoints:$leftPoints");
//                               return IndividualMacrosTrackerLineChartSF(
//                                 macroName: macroName,
//                                 dailyValue: dailyMacroValue,
//                                 bottomPoints: bottomPoints,
//                                 leftPoints: leftPoints,
//                                 data: DashboardService.to.graphMacrosConsumed.value,
//                                 interval: interval,
//                                 macroLineColor: macroLineColor,
//                               );
//                             },
//                           ),
//                         ).marginSymmetric(horizontal: 15);
//                       } else {
//                         return const SizedBox.shrink();
//                       }
//                     },
//                   ),
//                 ),
//                 Wrap(
//                   spacing: 12,
//                   runSpacing: 8,
//                   alignment: WrapAlignment.center,
//                   children: [
//                     _buildLegend(glCaloriesColor, "Calories (Kcal)"),
//                     _buildLegend(glCarbColor, "Carb (g)"),
//                     _buildLegend(glProteinColor, "Protein (g)"),
//                     _buildLegend(glFatColor, "Fat (g)"),
//                     _buildLegend(glFiberColor, "Fiber (g)"),
//                     _buildLegend(glWaterColor, "Water (L)"),
//                   ],
//                 ).paddingSymmetric(vertical: 10, horizontal: 10),
//                 SizedBox(
//                   height: Get.width * 0.05,
//                 ),
//                 */ /*SizedBox(
//                   height: Get.height - 60,
//                   width: Get.width,
//                   child: ListView(
//                     children: [
//                       Row(

//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Detailed Analytics",
//                             style: TextStyle(color: glDashboardPrimaryDarkColor, fontSize: 16, fontWeight: FontWeight.w700),
//                           ),
//                           */ /* */ /*Container(
//                                     height: 30,
//                                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(colors: glPrimaryGradient),
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: DropdownButtonHideUnderline(
//                                       child: DropdownButton(
//                                         items: ["Weekly", "Monthly"]
//                                             .map(
//                                               (name) => DropdownMenuItem(
//                                                 value: name,
//                                                 child: Text(
//                                                   name,
//                                                   style: TextStyle(color: glLightDividerColor, fontSize: 14),
//                                                 ),
//                                               ),
//                                             )
//                                             .toList(),
//                                         onChanged: (value) {},
//                                         icon: Icon(Icons.expand_more, color: glLightPrimaryColor),
//                                         hint: Text(
//                                           "Weekly",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(color: glLightPrimaryColor, fontSize: 12),
//                                         ),
//                                       ),
//                                     ),
//                                   ),*/ /* */ /*
//                         ],
//                       ).marginSymmetric(horizontal: 15),
//                       SizedBox(
//                         height: Get.width * 0.05,
//                       ),
//                       InkWell(
//                         onTap: () => controller.showDateRangePicker(),
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Obx(
//                             () => Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Select Date Range'),
//                                 Row(
//                                   children: [
//                                     if (DashboardService.to.graphMacrosStartDate.value != null && DashboardService.to.graphMacrosEndDate.value != null)
//                                       Text('${DashboardService.to.graphMacrosStartDate.value} - ${DashboardService.to.graphMacrosEndDate.value}'),
//                                     if (DashboardService.to.graphMacrosStartDate.value == null && DashboardService.to.graphMacrosEndDate.value == null) const Text('No date range selected'),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: Get.width * 0.05,
//                       ),
//                       Wrap(
//                         children: List.generate(6, (index) {
//                           var macros = DashboardService.to.graphMacrosConsumed.value.first.toJson().keys;
//                           return CheckboxListTile(
//                             title: Text(macros.elementAt(index)),
//                             value: controller.isGraphChecked[index],
//                             onChanged: (value) {
//                               controller.isGraphChecked[index] = value!;
//                               controller.isGraphChecked.refresh();
//                             },
//                           );
//                         }),
//                       ),
//                       SizedBox(
//                         height: Get.width * 0.05,
//                       ),
//                       SizedBox(
//                         height: Get.width * (controller.isGraphChecked.where((element) => element == true).length),
//                         child: ListView.builder(
//                           itemCount: 6,
//                           itemBuilder: (context, index) {
//                             if (controller.isGraphChecked[index]) {
//                               return Container(
//                                 padding: const EdgeInsets.only(left: 0, right: 10),
//                                 height: Get.width,
//                                 width: Get.width,
//                                 child: Obx(
//                                   () {
//                                     List<String> bottomPoints = DashboardService.to.graphMacrosConsumed.value.map((e) => e.date).toList();
//                                     List<double> stats = DashboardService.to.graphMacrosConsumed.value.map((e) {
//                                       switch (index) {
//                                         case 0:
//                                           return e.calories.toDouble();
//                                         case 1:
//                                           return e.carb.toDouble();
//                                         case 2:
//                                           return e.protein.toDouble();
//                                         case 3:
//                                           return e.fat.toDouble();
//                                         case 4:
//                                           return e.fiber.toDouble();
//                                         case 5:
//                                           return e.water.toDouble();
//                                         default:
//                                           throw Exception("Invalid index");
//                                       }
//                                     }).toList();
//                                     for (var element in DashboardService.to.graphMacrosConsumed.value) {
//                                       //print("graphMacrosConsumed element ${element.calories}");
//                                     }
//                                     double toAdd = 0;
//                                     switch (index) {
//                                       case 0:
//                                         toAdd = 100;
//                                       case 1:
//                                         toAdd = 10;

//                                       case 2:
//                                         toAdd = 10;
//                                       case 3:
//                                         toAdd = 10;
//                                       case 4:
//                                         toAdd = 10;
//                                       case 5:
//                                         toAdd = 1;

//                                       default:
//                                         throw Exception("Invalid index");
//                                     }
//                                     double minVal = 0;
//                                     double maxVal = (stats.max() ?? 0) + toAdd;
//                                     //print("graphMacrosConsumed.max() $stats ${stats.max()}");
//                                     List<double> leftPoints = Helper.generateDoubleList(start: minVal, end: maxVal, interval: 50);
//                                     // //print("Length ${DashboardService.to.weightTrackingData.value.length} bottomPoints: $bottomPoints leftPoints:$leftPoints");
//                                     return IndividualMacrosTrackerLineChart(
//                                       macroName: index == 0
//                                           ? "calories"
//                                           : index == 1
//                                               ? "carb"
//                                               : index == 2
//                                                   ? "protein"
//                                                   : index == 3
//                                                       ? "fat"
//                                                       : index == 4
//                                                           ? "fiber"
//                                                           : "water",
//                                       dailyValue: index == 0
//                                           ? UserService.to.currentUser.value.dailyCalorieIntake
//                                           : index == 1
//                                               ? UserService.to.currentUser.value.dailyCarbIntake
//                                               : index == 2
//                                                   ? UserService.to.currentUser.value.dailyProteinIntake
//                                                   : index == 3
//                                                       ? UserService.to.currentUser.value.dailyFatsIntake
//                                                       : index == 4
//                                                           ? UserService.to.currentUser.value.dailyFiberIntake
//                                                           : UserService.to.currentUser.value.dailyWater,
//                                       bottomPoints: bottomPoints,
//                                       leftPoints: leftPoints,
//                                       data: DashboardService.to.graphMacrosConsumed.value,
//                                       interval: 50,
//                                     );
//                                   },
//                                 ),
//                               ).marginSymmetric(horizontal: 15);
//                             } else {
//                               return const SizedBox.shrink();
//                             }
//                           },
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               RoundContainer(
//                                 size: 10,
//                                 bgColor: glLightThemeColor,
//                               ).paddingOnly(right: 5),
//                               "Calories(Kcal)".text.size(9).minFontSize(9).make(),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               RoundContainer(
//                                 size: 10,
//                                 bgColor: glCarbColor,
//                               ).paddingOnly(right: 5),
//                               "Carb(g)".text.size(9).minFontSize(9).make(),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               RoundContainer(
//                                 size: 10,
//                                 bgColor: glProteinColor,
//                               ).paddingOnly(right: 5),
//                               "Protein(g)".text.size(9).minFontSize(9).make(),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               RoundContainer(
//                                 size: 10,
//                                 bgColor: glFatColor,
//                               ).paddingOnly(right: 5),
//                               "Fat(g)".text.size(9).minFontSize(9).make(),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               RoundContainer(
//                                 size: 10,
//                                 bgColor: glFiberColor,
//                               ).paddingOnly(right: 5),
//                               "Fiber(g)".text.size(9).minFontSize(9).make(),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               RoundContainer(
//                                 size: 10,
//                                 bgColor: glWaterColor,
//                               ).paddingOnly(right: 5),
//                               "Water(L)".text.size(9).minFontSize(9).make(),
//                             ],
//                           ),
//                         ],
//                       ).pSymmetric(v: 10, h: 10),
//                       SizedBox(
//                         height: Get.width * 0.05,
//                       ),
//                     ],
//                   ),
//                 ),*/ /*
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLegend(Color color, String label) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         RoundContainer(size: 10, bgColor: color).paddingOnly(right: 5),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 9),
//         ),
//       ],
//     );
//   }
// }*/
// class DetailedGraph extends GetView<DashboardController> {
//   const DetailedGraph({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.grey[100],
//           appBar: AppBarWidget(
//             height: 60,
//             title: "Detailed Analytics",
//             onTap: () {
//               if (!RootService.to.isOnHomePage.value) {
//                 RootService.to.isOnHomePage.value = true;
//                 DashboardService.to.currentPage.value = 0;
//                 DashboardService.to.currentPage.refresh();
//                 if (!controller.showHomeLoader.value) {
//                   DashboardService.to.pageController.value.animateToPage(
//                     DashboardService.to.currentPage.value,
//                     duration: const Duration(milliseconds: 100),
//                     curve: Curves.linear,
//                   );
//                   DashboardService.to.pageController.refresh();
//                 }
//               }
//             },
//           ),
//           body: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               _buildDateSelector(),
//               const SizedBox(height: 20),
//               _buildMacroCheckboxes(),
//               const SizedBox(height: 20),
//               _buildLegendRow(),
//               const SizedBox(height: 20),
//               _buildCharts(),
//               const SizedBox(height: 20),
//               _buildLegendsWrap(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateSelector() {
//     return InkWell(
//       onTap: () => controller.showDateRangePicker(),
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Obx(() => Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildDateTile("Start Date", (DashboardService.to.graphMacrosStartDate.value).toString()),
//                 const Icon(Icons.arrow_forward, color: Colors.grey),
//                 _buildDateTile("End Date", (DashboardService.to.graphMacrosEndDate.value).toString()),
//               ],
//             )),
//       ),
//     );
//   }

//   Widget _buildDateTile(String title, String date) {
//     return Column(
//       children: [
//         Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         const SizedBox(height: 6),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             date,
//             style: TextStyle(fontWeight: FontWeight.w600, color: date == "Select" ? Colors.grey : Colors.black),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMacroCheckboxes() {
//     final macroKeys = DashboardService.to.graphMacrosConsumed.value.first.toJson().keys.toList();
//     return Obx(() {
//       return Wrap(
//         spacing: 16,
//         runSpacing: 12,
//         alignment: WrapAlignment.center,
//         children: List.generate(6, (index) {
//           final isSelected = controller.isGraphChecked[index];
//           final label = macroKeys[index].capitalized;

//           return GestureDetector(
//             onTap: () {
//               controller.isGraphChecked[index] = !isSelected;
//               controller.isGraphChecked.refresh();
//             },
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Checkbox(
//                   value: isSelected,
//                   onChanged: (val) {
//                     controller.isGraphChecked[index] = val!;
//                     controller.isGraphChecked.refresh();
//                   },
//                   activeColor: glAccentColor,
//                   visualDensity: VisualDensity.compact,
//                 ),
//                 Text(
//                   label,
//                   style: const TextStyle(fontSize: 13),
//                 ),
//               ],
//             ),
//           );
//         }),
//       );
//     });
//   }

//   Widget _buildLegendRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         RoundContainer(size: 10, bgColor: Colors.black).paddingOnly(right: 5),
//         const Text("Daily Required Values", style: TextStyle(fontSize: 10)),
//       ],
//     );
//   }

//   Widget _buildCharts() {
//     return Obx(() {
//       return Column(
//         children: List.generate(6, (index) {
//           if (!controller.isGraphChecked[index]) return const SizedBox.shrink();

//           List<String> bottomPoints = DashboardService.to.graphMacrosConsumed.value.map((e) => e.date).toList();
//           List<num> stats = DashboardService.to.graphMacrosConsumed.value.map((e) {
//             switch (index) {
//               case 0:
//                 return e.calories.toDouble();
//               case 1:
//                 return e.carb.toDouble();
//               case 2:
//                 return e.protein.toDouble();
//               case 3:
//                 return e.fat.toDouble();
//               case 4:
//                 return e.fiber.toDouble();
//               case 5:
//                 return e.water.toDouble();
//               default:
//                 return 0;
//             }
//           }).toList();

//           int toAdd = [100, 10, 10, 10, 5, 1][index];
//           double dailyMacroValue = [
//             UserService.to.currentUser.value.dailyCalorieIntake,
//             UserService.to.currentUser.value.dailyCarbIntake,
//             UserService.to.currentUser.value.dailyProteinIntake,
//             UserService.to.currentUser.value.dailyFatsIntake,
//             UserService.to.currentUser.value.dailyFiberIntake,
//             UserService.to.currentUser.value.dailyWater
//           ][index];
//           String macroName = ["calories", "carb", "protein", "fat", "fiber", "water"][index];
//           double interval = [100.0, 10.0, 10.0, 10.0, 10.0, 0.5][index];
//           Color macroLineColor = [glCaloriesColor, glCarbColor, glProteinColor, glFatColor, glFiberColor, glWaterColor][index];
//           num maxStat = stats.isEmpty ? 0 : stats.reduce((a, b) => a > b ? a : b);
//           num maxVal = (maxStat == 0 ? dailyMacroValue : maxStat) + toAdd;
//           // double maxVal = (stats.max() == 0 ? dailyMacroValue : (stats.max() ?? 0)) + toAdd;
//           List<double> leftPoints = Helper.generateDoubleList(start: 0, end: maxVal.toDouble(), interval: index == 0 ? 50 : 1);
//           //print("maxStat $maxStat maxVal $maxVal leftPoints $leftPoints ${DashboardService.to.graphMacrosConsumed.value}");

//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: IndividualMacrosTrackerLineChartSF(
//               macroName: macroName,
//               dailyValue: dailyMacroValue,
//               bottomPoints: bottomPoints,
//               leftPoints: leftPoints,
//               data: DashboardService.to.graphMacrosConsumed.value,
//               interval: interval,
//               macroLineColor: macroLineColor,
//             ),
//           );
//         }),
//       );
//     });
//   }

//   Widget _buildLegendsWrap() {
//     return Wrap(
//       spacing: 12,
//       runSpacing: 8,
//       alignment: WrapAlignment.center,
//       children: [
//         _buildLegend(glCaloriesColor, "Calories (Kcal)"),
//         _buildLegend(glCarbColor, "Carb (g)"),
//         _buildLegend(glProteinColor, "Protein (g)"),
//         _buildLegend(glFatColor, "Fat (g)"),
//         _buildLegend(glFiberColor, "Fiber (g)"),
//         _buildLegend(glWaterColor, "Water (L)"),
//       ],
//     );
//   }

//   Widget _buildLegend(Color color, String label) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         RoundContainer(size: 10, bgColor: color).paddingOnly(right: 5),
//         Text(label, style: const TextStyle(fontSize: 10)),
//       ],
//     );
//   }
// }
