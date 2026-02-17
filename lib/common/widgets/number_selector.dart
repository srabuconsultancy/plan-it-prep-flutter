import 'package:flutter/material.dart';

import '../../core.dart'; // Assuming MealPlanService is defined here

class NumberSelector extends StatefulWidget {
  const NumberSelector({
    super.key,
    required this.value,
    required this.selectedUnit,
  });

  final double value;
  final String selectedUnit;

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  late double _currentValue;
  late double _incrementVal;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    MealPlanService.to.selectedServingSize.value = widget.selectedUnit;
    MealPlanService.to.selectedServingSize.refresh();

    if (widget.selectedUnit.toLowerCase() == "cup") {
      _incrementVal = 0.25;
    } else if (widget.selectedUnit.toLowerCase().contains("piece")) {
      _incrementVal = 1;
    } else if (widget.selectedUnit.toLowerCase() == "g") {
      _incrementVal = 5.0;
    } else {
      _incrementVal = 1;
    }
  }

  // Increment the value
  void _increment() {
    setState(() {
      _currentValue += _incrementVal;
      MealPlanService.to.selectedQty.value = _currentValue;
      MealPlanService.to.selectedQty.refresh();
    });
  }

  // Decrement the value
  void _decrement() {
    setState(() {
      if (_currentValue - _incrementVal >= 0) {
        _currentValue -= _incrementVal;
        MealPlanService.to.selectedQty.value = _currentValue;
        MealPlanService.to.selectedQty.refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decrement button
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _decrement,
            ),
            // Number input field
            SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  setState(() {
                    _currentValue = double.tryParse(text) ?? 0.0;
                    MealPlanService.to.selectedQty.value = _currentValue;
                    MealPlanService.to.selectedQty.refresh();
                  });
                },
                controller: TextEditingController(
                  text: _currentValue.toStringAsFixed(2),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Increment button
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _increment,
            ),
          ],
        ),
      ],
    );
  }
}
