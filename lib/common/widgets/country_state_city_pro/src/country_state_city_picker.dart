import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../../core.dart';

class CountryStateCityPicker extends StatefulWidget {
  final TextEditingController countryTextController;
  final TextEditingController stateTextController;
  final TextEditingController cityTextController;
  final InputDecoration? textFieldDecoration;
  final Color? dialogColor;

  const CountryStateCityPicker({super.key, required this.countryTextController, required this.stateTextController, required this.cityTextController, this.textFieldDecoration, this.dialogColor});
  @override
  State<CountryStateCityPicker> createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  RootService rootService = Get.find();
  UserController authController = Get.find();
  final _countryList = <Country>[].obs;
  final _stateList = <StateLocation>[].obs;
  final _cityList = <City>[].obs;
  final _title = "".obs;
  var lastCountryId = 0.obs;
  var lastStateId = 0.obs;
  final _countrySubList = <Country>[].obs;
  final _stateSubList = <StateLocation>[].obs;
  final _citySubList = <City>[].obs;

  @override
  void initState() {
    _getCountry();
    super.initState();
  }

  Future<void> _getCountry() async {
    // _countryList.clear();
    setState(() {
      List<Country> countries = List.from(rootService.config.value.countries);

      _countryList.value = List.from(countries);
      _countryList.refresh();
      _countrySubList.value = List.from(countries);
      _countrySubList.refresh();
    });
  }

  Future<void> _getState() async {
    // _stateList.value.clear();
    // _cityList.value.clear();
    List<StateLocation> subStateList = [];
    var data = await Helper.sendRequestToServer(endPoint: "get-states", requestData: {"country_id": authController.selectedCountry.value.id.toString()});
    var response = json.decode(data.body);
    //print("_getState jsonString $response ${authController.selectedCountry.value.id}");
    List<dynamic> body = response["data"];

    subStateList = body.map((data) {
      return StateLocation.fromJson(data);
    }).toList();
    // body.map((dynamic item) => StateModel.fromJson(item)).toList();

    _stateList.value = List.from(subStateList);
    _stateList.refresh();
    _stateSubList.value = List.from(subStateList);
    _stateSubList.refresh();

    //print("_getState _stateSubList ${_stateSubList.length} ${_stateList.length}");
  }

  Future<void> _getCity() async {
    // _cityList.clear();
    List<City> subCityList = [];
    var data = await Helper.sendRequestToServer(endPoint: "get-cities", requestData: {"state_id": authController.selectedState.value.id.toString()});
    var response = json.decode(data.body);
    //print("_getCity jsonString $response ${authController.selectedState.value.id}");
    List<dynamic> body = response["data"];
    subCityList = body.map((dynamic item) => City.fromJson(item)).toList();
    _cityList.value = List.from(subCityList);
    _cityList.refresh();
    _citySubList.value = List.from(subCityList);
    _citySubList.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select Your Country',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: glDarkPrimaryColor,
            height: 1,
            shadows: const [
              // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
            ],
          ),
        )
            .animate()
            .shimmer(
              delay: 66.ms,
              duration: 400.ms,
              color: glLightThemeColor,
            )
            .fadeIn(
              duration: 400.ms,
              delay: 66.ms,
              curve: Curves.easeOutQuad,
            )
            .slideX()
            .objectCenterLeft(),
        const SizedBox(
          height: 20,
        ),

        ///Country TextField
        Obx(
          () => TextField(
            controller: widget.countryTextController,
            onTap: () {
              _title.value = 'Country';
              _title.refresh();
              _getCountry();
              _showDialog(context);
            },
            decoration: (widget.textFieldDecoration == null ? defaultDecoration.copyWith(hintText: 'Select country') : widget.textFieldDecoration?.copyWith(hintText: 'Select country'))!.copyWith(
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 30,
                height: 25,
                child: Center(
                  child: authController.selectedCountry.value.name == ""
                      ? const Icon(Icons.language)
                      : Text(
                          authController.selectedCountry.value.flagEmoji,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                ),
              ),
            ),
            readOnly: true,
          )
              .animate()
              .fadeIn(
                duration: 400.ms,
                curve: Curves.easeOutQuad,
                delay: 66.ms,
              )
              .slideX()
              .objectCenterLeft(),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Select Your State',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: glDarkPrimaryColor,
            height: 1,
            shadows: const [
              // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
            ],
          ),
        )
            .animate()
            .shimmer(
              delay: 66.ms,
              duration: 400.ms,
              color: glLightThemeColor,
            )
            .fadeIn(
              duration: 400.ms,
              delay: 66.ms,
              curve: Curves.easeOutQuad,
            )
            .slideX()
            .objectCenterLeft(),
        const SizedBox(
          height: 20,
        ),

        ///State TextField
        TextField(
          controller: widget.stateTextController,
          onTap: () {
            _title.value = 'State';
            _title.refresh();
            if (widget.countryTextController.text.isNotEmpty) {
              _showDialog(context);
            } else {
              Helper.showToast(msg: 'Select Country', type: "info");
            }
          },
          decoration: widget.textFieldDecoration == null
              ? defaultDecoration.copyWith(
                  hintText: 'Select state',
                  // contentPadding: const EdgeInsets.only(left: 45),
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 30,
                    height: 25,
                  ),
                )
              : widget.textFieldDecoration?.copyWith(
                  hintText: 'Select state',
                  // contentPadding: const EdgeInsets.only(left: 45),
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 30,
                    height: 25,
                  ),
                ),
          readOnly: true,
        )
            .animate()
            .fadeIn(
              duration: 400.ms,
              curve: Curves.easeOutQuad,
              delay: 66.ms,
            )
            .slideX(),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Select Your City',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: glDarkPrimaryColor,
            height: 1,
            shadows: const [
              // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
            ],
          ),
        )
            .animate()
            .shimmer(
              delay: 66.ms,
              duration: 400.ms,
              color: glLightThemeColor,
            )
            .fadeIn(
              duration: 400.ms,
              delay: 66.ms,
              curve: Curves.easeOutQuad,
            )
            .slideX()
            .objectCenterLeft(),
        const SizedBox(
          height: 20,
        ),

        ///City TextField
        TextField(
          controller: widget.cityTextController,
          onTap: () {
            _title.value = 'City';
            _title.refresh();
            if (widget.stateTextController.text.isNotEmpty) {
              _showDialog(context);
            } else {
              Helper.showToast(msg: 'Select State', type: "info");
            }
          },
          decoration: widget.textFieldDecoration == null
              ? defaultDecoration.copyWith(
                  hintText: 'Select city',
                  // contentPadding: const EdgeInsets.only(left: 45),
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 30,
                    height: 25,
                  ),
                )
              : widget.textFieldDecoration?.copyWith(
                  hintText: 'Select city',
                  // contentPadding: const EdgeInsets.only(left: 45),
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 30,
                    height: 25,
                  ),
                ),
          readOnly: true,
        )
            .animate()
            .fadeIn(
              duration: 400.ms,
              curve: Curves.easeOutQuad,
              delay: 66.ms,
            )
            .slideX(),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    final TextEditingController controller1 = TextEditingController();
    final TextEditingController controller2 = TextEditingController();
    final TextEditingController controller3 = TextEditingController();
    _countrySubList.value = List.from(_countryList.value);
    _countrySubList.refresh();
    _stateSubList.value = List.from(_stateList.value);
    _stateSubList.refresh();
    _citySubList.value = List.from(_cityList.value);
    _citySubList.refresh();
    showGeneralDialog(
      barrierLabel: _title.value,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 350),
      context: context,
      pageBuilder: (context, __, ___) {
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Obx(
                () => Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: Get.height * .7,
                    margin: const EdgeInsets.only(top: 60, left: 12, right: 12),
                    decoration: BoxDecoration(
                      color: widget.dialogColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(_title.value, style: TextStyle(color: Colors.grey.shade800, fontSize: 17, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),

                        ///Text Field
                        TextField(
                          controller: _title.value == 'Country'
                              ? controller1
                              : _title.value == 'State'
                                  ? controller2
                                  : controller3,
                          onChanged: (val) {
                            if (val.isEmpty) {
                              if (_title.value == 'Country') {
                                _countrySubList.value = List.from(_countryList.value);
                                _countrySubList.refresh();
                              } else if (_title.value == 'State') {
                                _stateSubList.value = List.from(_stateList.value);
                                _stateSubList.refresh();
                              } else {
                                _citySubList.value = List.from(_cityList.value);
                                _citySubList.refresh();
                              }
                            }
                            if (_title.value == 'Country') {
                              //print("_title $_title $val ${controller1.text} ${_countryList.length} ${controller1.text.toLowerCase()}");
                              _countrySubList.value = List.from(List.from(_countryList.where((element) => element.name.toLowerCase().contains(controller1.text.toLowerCase()))).toList());
                              _countrySubList.refresh();
                            } else if (_title.value == 'State') {
                              //print("_title $_title $val ${controller1.text} ${_stateList.length} ${controller2.text.toLowerCase()}");
                              _stateSubList.value = List.from(List.from(_stateList.where((element) => element.name.toLowerCase().contains(controller2.text.toLowerCase()))).toList());
                              _stateSubList.refresh();
                            } else if (_title.value == 'City') {
                              //print("_title $_title $val ${controller1.text} ${_cityList.length} ${controller3.text.toLowerCase()}");
                              _citySubList.value = List.from(List.from(_cityList.where((element) => element.name.toLowerCase().contains(controller3.text.toLowerCase()))).toList());
                              _citySubList.refresh();
                            }
                            //print("_countrySubList ${_countrySubList.length}");
                          },
                          style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Search here...",
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            isDense: true,
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),

                        ///Dropdown Items
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            itemCount: _title.value == 'Country'
                                ? _countrySubList.length
                                : _title.value == 'State'
                                    ? _stateSubList.length
                                    : _citySubList.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  if (_title.value == "Country") {
                                    authController.selectedCountry.value = _countrySubList[index];
                                    widget.countryTextController.text = _countrySubList[index].name;

                                    //print("_countrySubList[index].id ${_countrySubList[index].id} ${lastCountryId.value}");
                                    if (lastCountryId.value != authController.selectedCountry.value.id) {
                                      Get.backLegacy(closeOverlays: true);
                                      EasyLoading.show(status: "Please wait..", dismissOnTap: false);
                                      await _getState();
                                      EasyLoading.dismiss();
                                    } else {}
                                    lastCountryId.value = _countrySubList[index].id;
                                    lastCountryId.refresh();
                                    _countrySubList.value = List.from(_countryList.value);
                                    _countrySubList.refresh();
                                    widget.stateTextController.clear();
                                    widget.cityTextController.clear();
                                    authController.selectedState.value = StateLocation();
                                  } else if (_title.value == 'State') {
                                    authController.selectedState.value = _stateSubList[index];
                                    widget.stateTextController.text = _stateSubList[index].name;
                                    //print("_stateSubList[index].id ${_stateSubList[index].id} ${lastStateId.value}");
                                    if (lastStateId.value != authController.selectedState.value.id) {
                                      Get.backLegacy(closeOverlays: true);
                                      EasyLoading.show(status: "Please wait..", dismissOnTap: false);
                                      await _getCity();
                                      EasyLoading.dismiss();
                                    } else {}
                                    lastStateId.value = _stateSubList[index].id;
                                    lastStateId.refresh();
                                    _stateSubList.value = List.from(_stateList.value);
                                    _stateSubList.refresh();
                                    widget.cityTextController.clear();
                                    authController.selectedCity.value = City();
                                  } else if (_title.value == 'City') {
                                    authController.selectedCity.value = _citySubList[index];
                                    widget.cityTextController.text = _citySubList[index].name;
                                    _citySubList.value = List.from(_cityList.value);
                                    _citySubList.refresh();
                                    Get.backLegacy(closeOverlays: true);
                                  }
                                  controller1.clear();
                                  controller2.clear();
                                  controller3.clear();
                                  // Navigator.of(Get.context!).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
                                  child: Row(
                                    children: [
                                      if (_title.value == "Country") Text(_countrySubList[index].flagEmoji, style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0)),
                                      if (_title.value == "Country")
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      Text(
                                          _title.value == 'Country'
                                              ? _countrySubList[index].name
                                              : _title.value == 'State'
                                                  ? _stateSubList[index].name
                                                  : _citySubList[index].name,
                                          style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))),
                          onPressed: () {
                            if (_title.value == 'City' && _citySubList.isEmpty) {
                              widget.cityTextController.text = controller3.text;
                            }
                            _countrySubList.value = List.from(_countryList.value);
                            _countrySubList.refresh();
                            _stateSubList.value = List.from(_stateList.value);
                            _stateSubList.refresh();
                            _citySubList.value = List.from(_cityList.value);
                            _citySubList.refresh();
                            controller1.clear();
                            controller2.clear();
                            controller3.clear();
                            //Get.back(closeOverlays: true);
                            Get.backLegacy(closeOverlays: true);
                          },
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  InputDecoration defaultDecoration = const InputDecoration(isDense: true, hintText: 'Select', suffixIcon: Icon(Icons.arrow_drop_down), border: OutlineInputBorder());
}
