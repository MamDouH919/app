import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';

class MyTextFieldDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;
  final String? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? dateFormat;
  final FocusNode? focusNode;
  final String? labelText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Color? primaryColor;
  final Color? onPrimary;
  final String? errorText;
  final String Function(String?)? validator;
  MyTextFieldDatePicker(
      {Key? key,
      this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.focusNode,
      this.dateFormat,
      this.lastDate,
      this.firstDate,
      this.initialDate,
      required this.onDateChanged,
      this.primaryColor,
      this.onPrimary,
      this.errorText,
      this.validator})
      : super(key: key);

  @override
  _MyTextFieldDatePicker createState() => _MyTextFieldDatePicker();
}

class _MyTextFieldDatePicker extends State<MyTextFieldDatePicker> {
  late TextEditingController _controllerDate;
  late DateFormat _dateFormat;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat!;
    } else {
      _dateFormat = DateFormat(DateFormat.YEAR_MONTH_DAY);
    }

    _controllerDate = TextEditingController();

    if (widget.initialDate == null || widget.initialDate!.isEmpty) {
      _controllerDate.text = "";
      _selectedDate = DateTime.now();
    } else {
      _selectedDate = DateTime.parse(widget.initialDate!);
      _controllerDate.text = _dateFormat.format(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: widget.primaryColor,
          colorScheme: ColorScheme.light(
            primary: widget.primaryColor!, // header background color
            onPrimary: widget.onPrimary!, // header text color
            onSurface: widget.primaryColor!, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                primary: widget.primaryColor // button text color
                ),
          ),
        ),
        child: Builder(builder: (context) {
          return TextFormField(
            focusNode: widget.focusNode,
            controller: _controllerDate,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              labelText: widget.labelText,
              errorText: widget.errorText,
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ThemeSettings.smallBorderRadius),
                borderSide: const BorderSide(
                  width: 1.0,
                  color: ThemeSettings.errorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(ThemeSettings.smallBorderRadius),
                borderSide: const BorderSide(
                  width: 1.0,
                  color: ThemeSettings.errorColor,
                ),
              ),
            ),
            onTap: () => _selectDate(context),
            readOnly: true,
            validator: widget.validator,
          );
        }));
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate!,
      lastDate: widget.lastDate!,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _dateFormat.format(_selectedDate);
      widget.onDateChanged(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode!.nextFocus();
    }
  }
}
