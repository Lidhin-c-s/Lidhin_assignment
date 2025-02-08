import 'package:assignment/core/dependency_injection.dart';
import 'package:assignment/features/home/bloc/home_bloc.dart';
import 'package:assignment/features/home/bloc/home_event.dart';
import 'package:assignment/features/home/bloc/home_state.dart';
import 'package:assignment/features/home/employee_model.dart';
import 'package:assignment/share/theme/theme_colors.dart';
import 'package:assignment/share/theme/theme_size.dart';
import 'package:assignment/share/widgets/custom_app_bar.dart';
import 'package:assignment/share/widgets/custom_button.dart';
import 'package:assignment/share/widgets/custom_date_picker.dart';
import 'package:assignment/share/widgets/custom_svg.dart';
import 'package:assignment/share/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeAddScreen extends StatefulWidget {
  const EmployeeAddScreen({super.key, this.employee, this.index});
  final Employee? employee;
  final int? index;

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  DateTime? _selectedDate = DateTime.now();
  DateTime? _endDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee?.name ?? '';
      _designationController.text = widget.employee?.designation ?? '';
      _selectedDate = widget.employee?.startDate;
      _endDate = widget.employee?.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<HomeBloc>(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.employee != null
              ? "Edit Employee Details"
              : "Add Employee Details",
          actions: [
            if (widget.employee != null)
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeEvent.deleteEmployee(widget.index!),
                        );
                  },
                  icon: const CustomSvg(
                    assetName: "assets/delete.svg",
                  ),
                );
              }),
          ],
        ),
        body: SafeArea(
          child: Column(
            spacing: ThemeSize.fieldSpacing,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: ThemeSize.fieldSpacing),
              _buildTextField(
                hintText: "Employee name",
                icon: "assets/person.svg",
                controller: _nameController,
              ),
              _buildDropdownField(
                  hintText: "Designation",
                  icon: "assets/work.svg",
                  controller: _designationController),
              _buildDatePickerRow(),
              const Spacer(),
              const Divider(color: ThemeColors.borderGrey),
              _buildBottomButtons(context),
              const SizedBox(height: ThemeSize.fieldSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hintText,
      required String icon,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: ThemeSize.textFieldHorizontalPadding),
      child: CustomTextfield(
        hintText: hintText,
        icon: CustomSvg(
          assetName: icon,
        ),
        controller: controller,
      ),
    );
  }

  Widget _buildDropdownField(
      {required String hintText,
      required String icon,
      required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeSize.textFieldHorizontalPadding,
      ),
      child: CustomTextfield(
        hintText: hintText,
        icon: CustomSvg(
          assetName: icon,
        ),
        isReadOnly: true,
        controller: controller,
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
          color: ThemeColors.primary,
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  "Product Designer",
                  "Flutter Developer",
                  "QA Tester",
                  "Product Owner"
                ].map((item) {
                  return _buildBottomSheetItem(item, context,
                      needDivider: item != "Designer");
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomSheetItem(String item, BuildContext context,
      {bool needDivider = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text(item, textAlign: TextAlign.center),
          onTap: () {
            _designationController.text = item;
            Navigator.pop(context, item);
          },
        ),
        if (needDivider) const Divider(),
      ],
    );
  }

  Widget _buildDatePickerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildDateButton(
              label: _selectedDate == null ||
                      isSameDay(_selectedDate!, DateTime.now())
                  ? "Today"
                  : getFormattedDate(_selectedDate!),
              initialDate: _selectedDate,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_forward,
              color: ThemeColors.primary,
              size: ThemeSize.iconSize,
            ),
          ),
          Expanded(
            child: _buildDateButton(
              label: _endDate == null ? "No date" : getFormattedDate(_endDate!),
              noDate: true,
              initialDate: _endDate,
            ),
          ),
        ],
      ),
    );
  }

  String getFormattedDate(DateTime date) {
    return DateFormat("dd MMM yyyy").format(date);
  }

  Widget _buildDateButton(
      {required String label, bool noDate = false, DateTime? initialDate}) {
    return CustomTextfield(
      hintText: label,
      icon: const CustomSvg(
        assetName: "assets/calendar.svg",
      ),
      isReadOnly: true,
      controller: TextEditingController(text: label),
      onTap: () {
        showCustomDatePicker(
          noDate: noDate,
          initialDate: initialDate,
        );
      },
    );
  }

  void showCustomDatePicker({bool noDate = false, DateTime? initialDate}) {
    showDialog(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialDate: initialDate ?? DateTime.now(),
        onDateSelected: (DateTime? newDate) {
          setState(() {
            if (noDate) {
              _endDate = newDate;
            } else {
              _selectedDate = newDate;
            }
          });
        },
        noDate: noDate,
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: ThemeSize.textFieldHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            callback: () {
              Navigator.pop(context);
            },
            text: "Cancel",
            selected: false,
          ),
          const SizedBox(width: 10),
          BlocListener<HomeBloc, HomeState>(
            bloc: getIt<HomeBloc>(),
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
                initial: () {},
                loaded: (employees) {
                  Navigator.pop(context);
                },
                updated: (employees) {
                  Navigator.pop(context);
                },
              );
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Builder(builder: (context) {
                  return CustomButton(
                    callback: () {
                      print('Name: ${_nameController.text}');
                      print('Designation: ${_designationController.text}');
                      print('Start Date: $_selectedDate');

                      if (_nameController.text.isNotEmpty &&
                          _designationController.text.isNotEmpty) {
                        if (widget.employee != null) {
                          context.read<HomeBloc>().add(
                                HomeEvent.updateEmployee(
                                  Employee(
                                    name: _nameController.text,
                                    designation: _designationController.text,
                                    startDate: _selectedDate ?? DateTime.now(),
                                    endDate: _endDate,
                                  ),
                                  widget.index!,
                                ),
                              );
                        } else {
                          context.read<HomeBloc>().add(
                                HomeEvent.add(
                                  Employee(
                                    name: _nameController.text,
                                    designation: _designationController.text,
                                    startDate: _selectedDate ?? DateTime.now(),
                                    endDate: _endDate,
                                  ),
                                ),
                              );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all the fields"),
                          ),
                        );
                      }
                    },
                    text: 'Save',
                    selected: true,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
