import 'package:assignment/share/theme/theme_colors.dart';
import 'package:assignment/share/theme/theme_size.dart';
import 'package:assignment/share/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime?) onDateSelected;
  final bool noDate;

  const CustomDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    this.noDate = false,
  });

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime? _selectedDate;
  int _selectedIndex = 0; // Track selected button index

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  String getFormattedDate(DateTime? date) {
    return date != null
        ? DateFormat("dd MMM yyyy").format(date)
        : "No Date Selected";
  }

  List<DateTime?> _getHeaderDates() {
    DateTime today = DateTime.now();

    return widget.noDate
        ? [null, today]
        : [
            today, // Today
            today.add(const Duration(days: 0)),
            today.add(const Duration(days: 7)),
            today.add(const Duration(days: 14)),
          ];
  }

  void _onHeaderDateSelected(int index, DateTime? date) {
    setState(() {
      _selectedDate = date;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime?> headerDates = _getHeaderDates();
    final bool showFullHeader = !widget.noDate;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              spacing: ThemeSize.fieldSpacing,
              children: [
                Row(
                  children: List.generate(2, (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 0 ? 8 : 0),
                        child: CustomButton(
                          callback: () =>
                              _onHeaderDateSelected(index, headerDates[index]),
                          text: index == 0 ? "No Date" : "Today",
                          selected: _selectedIndex == index,
                        ),
                      ),
                    );
                  }),
                ),
                if (showFullHeader)
                  Row(
                    children: List.generate(2, (index) {
                      int adjustedIndex = index + 2;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: index == 0 ? 8 : 0),
                          child: CustomButton(
                            callback: () => _onHeaderDateSelected(
                                adjustedIndex, headerDates[adjustedIndex]),
                            text: adjustedIndex == 2
                                ? DateFormat('EEEE')
                                    .format(headerDates[adjustedIndex]!)
                                : "After 1 Week",
                            selected: _selectedIndex == adjustedIndex,
                          ),
                        ),
                      );
                    }),
                  ),
              ],
            ),
            const Divider(),
            CalendarDatePicker(
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateChanged: (newDate) {
                setState(() {
                  _selectedDate = newDate;
                  // Reset the selected index when manually picking a date
                  _selectedIndex = -1;
                });
              },
              currentDate: _selectedDate,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 20, color: ThemeColors.primary),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            getFormattedDate(_selectedDate),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      CustomButton(
                        callback: () => Navigator.pop(context),
                        text: "Cancel",
                        selected: false,
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        callback: () {
                          // Pass null if "No Date" is selected (index 0)
                          widget.onDateSelected(
                              _selectedIndex == 0 ? null : _selectedDate);
                          Navigator.pop(context);
                        },
                        text: "Save",
                        selected: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
