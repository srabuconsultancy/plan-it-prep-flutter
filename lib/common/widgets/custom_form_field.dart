import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.textFieldController,
    required this.textFieldKey,
    this.textFieldBgColor = Colors.white,
    this.textFieldHeight = 50,
    this.textFieldBorderRadius = 20,
    this.textFieldMargin = const EdgeInsets.all(10),
    this.textFieldContentPadding = const EdgeInsets.all(10),
    this.textFieldOnSaved,
    this.textFieldOnChanged,
    this.textFieldOnTap,
    this.textFieldTextAlign = TextAlign.start,
    this.textFieldStyle,
    this.textFieldObscureText = false,
    this.textFieldEnabled = true,
    this.textFieldDense = false,
    this.textFieldEnabledBorderColor = Colors.lightGreen,
    this.textFieldFocusedBorderColor = Colors.blue,
    this.textFieldDisabledBorderColor = Colors.grey,
    this.textFieldBorderWidth = 0.5,
    this.textFieldElevation = 4,
    this.textFieldErrorColor = Colors.red,
    this.textFieldShadowColor = Colors.black54,
    this.textFieldFontSize = 14,
    this.textFieldFontWeight = FontWeight.normal,
    this.textFieldHintText = "Enter Name",
    this.textFieldHintTextColor = Colors.grey,
    this.textFieldLabelText = "Enter Name",
    this.textFieldLabelTextColor = Colors.grey,
    this.textFieldKeyboardType = TextInputType.text,
    this.textFieldWordSpacing = 2,
    this.textFieldFocusNode,
    this.textFieldInitialValue,
    this.textFieldValidator,
    this.textFieldPrefixIconWidget/*= const Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Icon(
        Icons.mail_outlined,
        color: Colors.white,
        shadows: <Shadow>[Shadow(offset: Offset(0.5, 0.5), blurRadius: 3.0, color: Colors.black)],
      ),
    )*/
    ,
    this.textFieldSuffixIconWidget/*= const Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Icon(
        Icons.cancel,
        color: Colors.white,
        shadows: <Shadow>[Shadow(offset: Offset(0.5, 0.5), blurRadius: 3.0, color: Colors.black)],
      ),
    )*/
    ,
    this.textFieldReadOnly = false,
    this.textFieldInputFormatters = const [],
  });

  final TextEditingController? textFieldController;
  final GlobalKey<FormFieldState> textFieldKey;
  final Color? textFieldBgColor;
  final double textFieldHeight;
  final double textFieldBorderRadius;
  final EdgeInsetsGeometry textFieldMargin;
  final EdgeInsetsGeometry textFieldContentPadding;
  final void Function(String?)? textFieldOnSaved;
  final void Function(String?)? textFieldOnChanged;
  final void Function()? textFieldOnTap;
  final TextAlign textFieldTextAlign;
  final TextStyle? textFieldStyle;
  final bool textFieldObscureText;
  final bool textFieldEnabled;
  final bool textFieldDense;
  final Color? textFieldEnabledBorderColor;
  final Color? textFieldFocusedBorderColor;
  final Color? textFieldDisabledBorderColor;
  final double textFieldBorderWidth;
  final double textFieldElevation;
  final Color? textFieldErrorColor;
  final Color? textFieldShadowColor;
  final double textFieldFontSize;
  final FontWeight? textFieldFontWeight;
  final String textFieldHintText;
  final Color? textFieldHintTextColor;
  final String textFieldLabelText;
  final Color? textFieldLabelTextColor;
  final TextInputType? textFieldKeyboardType;
  final double textFieldWordSpacing;
  final FocusNode? textFieldFocusNode;
  final String? textFieldInitialValue;
  final String? Function(String?)? textFieldValidator;
  final Widget? textFieldPrefixIconWidget;
  final Widget? textFieldSuffixIconWidget;
  final bool textFieldReadOnly;
  final List<TextInputFormatter> textFieldInputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: textFieldMargin,
      height: textFieldKey.currentState != null && textFieldKey.currentState!.validate() ? textFieldHeight : textFieldHeight + 30,
      child: Material(
        elevation: textFieldElevation,
        shadowColor: textFieldShadowColor,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(textFieldBorderRadius),
        ),
        child: TextFormField(
          key: textFieldKey,
          readOnly: textFieldReadOnly,
          onTap: textFieldOnTap,
          focusNode: textFieldFocusNode,
          initialValue: textFieldInitialValue,
          validator: textFieldValidator,
          enabled: textFieldEnabled,
          controller: textFieldController,
          textAlign: textFieldTextAlign,
          style: textFieldStyle,
          obscureText: textFieldObscureText,
          keyboardType: textFieldKeyboardType,
          inputFormatters: textFieldInputFormatters,
          onSaved: textFieldOnSaved,
          onChanged: textFieldOnChanged,
          decoration: InputDecoration(
            suffixIcon: textFieldSuffixIconWidget,
            isDense: textFieldDense,
            prefixIcon: textFieldPrefixIconWidget,
            filled: textFieldBgColor != null,
            fillColor: textFieldBgColor,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldEnabledBorderColor!, width: textFieldBorderWidth),
              borderRadius: BorderRadius.circular(textFieldBorderRadius),
            ),
            contentPadding: textFieldContentPadding,
            errorStyle: TextStyle(
              color: textFieldErrorColor,
              fontSize: textFieldFontSize,
              fontWeight: textFieldFontWeight,
              wordSpacing: textFieldWordSpacing,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldEnabledBorderColor!, width: textFieldBorderWidth),
              borderRadius: BorderRadius.circular(textFieldBorderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldFocusedBorderColor!, width: textFieldBorderWidth),
              borderRadius: BorderRadius.circular(textFieldBorderRadius),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldDisabledBorderColor!, width: textFieldBorderWidth),
              borderRadius: BorderRadius.circular(textFieldBorderRadius),
            ),
            hintText: textFieldHintText.tr,
            hintStyle: TextStyle(
              color: textFieldHintTextColor,
              fontSize: textFieldFontSize,
            ),
            labelText: textFieldLabelText,
            labelStyle: TextStyle(
              color: textFieldLabelTextColor,
              fontSize: textFieldFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
