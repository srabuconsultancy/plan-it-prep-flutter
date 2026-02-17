import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Make sure GetX is imported if you use .tr or .p()
import 'package:nutri_ai/core.dart'; // Ensure SvgPicture, Helper, Meal models are here

// --- 1. Converted to StatefulWidget ---
class HomepageMealWidget extends StatefulWidget {
  final Meal meal;
  const HomepageMealWidget({super.key, required this.meal});

  @override
  State<HomepageMealWidget> createState() => _HomepageMealWidgetState();
}

class _HomepageMealWidgetState extends State<HomepageMealWidget> {
  // --- State variable for expansion ---
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Access meal using widget.meal inside State
    final meal = widget.meal;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row (No changes here)
          Stack(
            children: [
              Container(
                height: 82,
                decoration: BoxDecoration(
                  color: meal.name == "Breakfast"
                      ? Color(0xFFFEEAE6)
                      : meal.name == "Morning Snack"
                          ? Color(0xFFFDF6E3)
                          : meal.name == "Lunch"
                              ? Color(0xFFE8F5E9)
                              : meal.name == "Evening Snack"
                                  ? Color(0xFFFCE4EC)
                                  : Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.zero,
                      semanticContainer: true,
                      color: glLightPrimaryColor,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: SvgPicture.asset(
                          meal.name == "Breakfast"
                              ? "assets/icons/breakfast.svg"
                              : meal.name == "Morning Snack"
                                  ? "assets/icons/morning-snack.svg"
                                  : meal.name == "Lunch"
                                      ? "assets/icons/dish.svg"
                                      : meal.name == "Evening Snack"
                                          ? "assets/icons/evening-snack.svg"
                                          : "assets/icons/supper.svg",
                        ).p(meal.name == "Breakfast" ? 10 : 5),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  meal.name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.local_fire_department,
                                        color: Colors.green, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      "${meal.macros!.calories}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: glLightPrimaryColor,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Text(
                      meal.name == "Breakfast"
                          ? "7:00–8:00 AM"
                          : meal.name == "Morning Snack"
                              ? "10:00–11:00 AM"
                              : meal.name == "Lunch"
                                  ? "12:00–2:00 PM"
                                  : meal.name == "Evening Snack"
                                      ? "3:00–4:00 PM"
                                      : "7:00–8:30 PM",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        shadows: [
                          Shadow(
                            color: Colors.white54,
                            offset: Offset(0.5, 0.5),
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Macro Details Padding (No changes here)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Macro details remain the same
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Protein",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12)),
                                Text(Helper.formatIfDecimal(meal.macros!.protein),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ).p(8),
                          ),
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Carbohydrates",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12)),
                                Text(Helper.formatIfDecimal(meal.macros!.carb),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ).p(8),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Fat",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12)),
                                Text(Helper.formatIfDecimal(meal.macros!.fat),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ).p(8),
                          ),
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Fiber",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12)),
                                Text(Helper.formatIfDecimal(meal.macros!.fiber),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ).p(8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // --- Added Divider ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Divider(color: Colors.grey.withOpacity(0.15), height: 1),
                ),
                // --- Added Expansion Button Row ---
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isExpanded ? "Hide Recipe".tr : "Show Recipe".tr,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: glAccentColor, // Use an appropriate color
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: glAccentColor, // Use an appropriate color
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                // ------------------------------------

                // --- Added AnimatedCrossFade ---
                // AnimatedCrossFade(
                //   firstChild: Container(height: 0), // Collapsed state
                //   secondChild: Padding(
                //     padding: const EdgeInsets.only(
                //         top: 4.0, left: 8.0, right: 8.0, bottom: 8.0),
                //     // --- Display Recipe Text ---
                //     // !! Assumes your Meal object has a 'recipe' property !!
                //     // !! Replace 'meal.recipe' if your property is named differently !!
                //     child: Text(
                //       meal.recipe ?? "Recipe not available.", // Handle null recipe
                //       style: TextStyle(
                //         fontSize: 13,
                //         color: Colors.black.withOpacity(0.7),
                //         height: 1.5, // Line spacing
                //       ),
                //     ),
                //     // ---------------------------
                //   ),
                //   crossFadeState: _isExpanded
                //       ? CrossFadeState.showSecond
                //       : CrossFadeState.showFirst,
                //   duration: const Duration(milliseconds: 300),
                //   firstCurve: Curves.easeOut,
                //   secondCurve: Curves.easeIn,
                //   sizeCurve: Curves.easeInOut,
                // ),
                // ------------------------------------
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- THIS FUNCTION IS NO LONGER USED, but kept as requested ---
  Color getDarkerColor(Color color) {
    return color.withRed((color.r * 0.8).round().clamp(0, 255)).withGreen((color.g * 0.8).round().clamp(0, 255)).withBlue((color.b * 0.8).round().clamp(0, 255));
  }
}