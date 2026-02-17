import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime today = DateTime.now();
  Timer? _debounce;

  final Duration _debounceDuration = const Duration(milliseconds: 1000);
  void _decrementDate() async {
    MealPlanService.to.selectedMealDate.value = MealPlanService.to.selectedMealDate.value.subtract(const Duration(days: 1));
    MealPlanService.to.selectedMealDate.refresh();
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new debounce timer
    _debounce = Timer(_debounceDuration, () async {
      MealPlanController mealPlanController = Get.find();
      if (MealPlanService.to.myMealPlanPage.value) {
        await mealPlanController.fetchMyMealPlan(date: DateFormat("yyyy-MM-dd").format(MealPlanService.to.selectedMealDate.value));
      } else {
        await mealPlanController.fetchMealPlan(day: mealPlanController.getDayNumber(DateFormat('EEEE').format(MealPlanService.to.selectedMealDate.value)));
      }
    });
  }

  void _incrementDate() async {
    MealPlanService.to.selectedMealDate.value = MealPlanService.to.selectedMealDate.value.add(const Duration(days: 1));
    MealPlanService.to.selectedMealDate.refresh();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Start a new debounce timer
    _debounce = Timer(_debounceDuration, () async {
      MealPlanController mealPlanController = Get.find();
      if (MealPlanService.to.myMealPlanPage.value) {
        await mealPlanController.fetchMyMealPlan(date: DateFormat("yyyy-MM-dd").format(MealPlanService.to.selectedMealDate.value));
      } else {
        await mealPlanController.fetchMealPlan(day: mealPlanController.getDayNumber(DateFormat('EEEE').format(MealPlanService.to.selectedMealDate.value)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: (MealPlanService.to.myMealPlanPage.value ? UserService.to.currentUser.value.registeredAt : UserService.to.currentUser.value.membershipStartDate!).isBefore(
              DateTime(
                MealPlanService.to.selectedMealDate.value.year,
                MealPlanService.to.selectedMealDate.value.month,
                MealPlanService.to.selectedMealDate.value.day,
                0,
                0,
                0,
              ),
            )
                ? _decrementDate
                : null,
            disabledColor: Colors.grey,
            color: Colors.blue,
          ),
          Text(
            DateFormat('EEEE, MMM d, yy').format(MealPlanService.to.selectedMealDate.value),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: (MealPlanService.to.myMealPlanPage.value ? DateTime.now() : UserService.to.currentUser.value.membershipEndDate!).isAfter(
              DateTime(
                MealPlanService.to.selectedMealDate.value.year,
                MealPlanService.to.selectedMealDate.value.month,
                MealPlanService.to.selectedMealDate.value.day,
                23,
                59,
                59,
              ),
            )
                ? _incrementDate
                : null,
            disabledColor: Colors.grey,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class DateSelector extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime selectedDate;
  final int totalDays; // Must be odd number like 7, 9, etc.

  const DateSelector({
    super.key,
    required this.onDateSelected,
    required this.selectedDate,
    this.totalDays = 7,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime selectedDate;
  late List<DateTime> visibleDates;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    visibleDates = _generateVisibleDatesAround(selectedDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  void _onDateTap(DateTime date) {
    setState(() {
      selectedDate = date;
      visibleDates = _generateVisibleDatesAround(date);
    });
    widget.onDateSelected(date);
    _scrollToSelected();
  }

  List<DateTime> _generateVisibleDatesAround(DateTime centerDate) {
    final int half = widget.totalDays ~/ 2;

    final now = DateTime.now();
    final endDate = MealPlanService.to.myMealPlanPage.value ? now : UserService.to.currentUser.value.membershipEndDate!;

    List<DateTime> list = [];

    for (int i = -half; i <= half; i++) {
      final d = centerDate.add(Duration(days: i));
      final endCutoff = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      if (d.isBefore(endCutoff.add(const Duration(days: 1)))) {
        list.add(d);
      }
    }

    return list;
  }

  void _scrollToSelected() {
    final int index = visibleDates.indexWhere((d) => d.year == selectedDate.year && d.month == selectedDate.month && d.day == selectedDate.day);

    if (index != -1) {
      final double itemWidth = 67; // width + margin approximation
      _scrollController.animateTo(
        index * itemWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: visibleDates.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final date = visibleDates[index];
          final isSelected = date.year == selectedDate.year && date.month == selectedDate.month && date.day == selectedDate.day;

          return GestureDetector(
            onTap: () => _onDateTap(date),
            child: Container(
              width: 55,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              padding: EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade200, width: 1),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.MMM().format(date),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    // const SizedBox(height: 2),
                    Text(
                      DateFormat.d().format(date),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    // const SizedBox(height: 2),
                    Text(
                      DateFormat.E().format(date),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
