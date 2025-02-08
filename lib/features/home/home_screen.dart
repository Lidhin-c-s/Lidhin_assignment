import 'dart:developer';

import 'package:assignment/core/dependency_injection.dart';
import 'package:assignment/features/employee/presentation/employee_op_screen.dart';
import 'package:assignment/features/home/bloc/home_bloc.dart';
import 'package:assignment/features/home/bloc/home_event.dart';
import 'package:assignment/features/home/bloc/home_state.dart';
import 'package:assignment/features/home/employee_model.dart';
import 'package:assignment/share/theme/theme_colors.dart';
import 'package:assignment/share/theme/theme_size.dart';
import 'package:assignment/share/widgets/custom_app_bar.dart';
import 'package:assignment/share/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Employee> employees = [];
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => getIt<HomeBloc>().add(
        const HomeEvent.getEmployee(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Employee List"),
      backgroundColor: ThemeColors.borderGrey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployeeAddScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocProvider.value(
        value: getIt<HomeBloc>(),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            state.maybeWhen(
              updated: (employees) {
                log("updated ${employees.map((e) => e.name)}");
                setState(() {
                  this.employees = employees;
                });
              },
              loaded: (employees) {
                setState(() {
                  this.employees = employees;
                });
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            bloc: getIt<HomeBloc>(),
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (employees) => _buildEmployeeList(),
                updated: (employees) => _buildEmployeeList(),
                orElse: () => const SizedBox(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList() {
    final currentEmployees = employees.where((e) => e.endDate == null).toList();
    final previousEmployees =
        employees.where((e) => e.endDate != null).toList();

    if (employees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/Group 5363.svg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'No employee records found',
              style: TextStyle(
                fontSize: ThemeSize.textFieldFontSize,
                color: ThemeColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        if (currentEmployees.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeSize.textFieldHorizontalPadding,
              vertical: ThemeSize.fieldSpacing,
            ),
            child: Text(
              'Current Employees',
              style: TextStyle(
                fontSize: ThemeSize.titleFontSize,
                color: ThemeColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...currentEmployees.asMap().entries.map((entry) => Column(
                children: [
                  EmployeeCard(
                    key: ValueKey(entry.value.name),
                    employee: entry.value,
                    index: entry.key,
                    onDelete: (index) {
                      getIt<HomeBloc>().add(HomeEvent.deleteEmployee(index));
                    },
                  ),
                  Divider(
                    height: 1,
                    color: ThemeColors.borderGrey.withValues(alpha: 0.1),
                  ),
                ],
              )),
        ],
        if (previousEmployees.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeSize.textFieldHorizontalPadding,
              vertical: ThemeSize.fieldSpacing,
            ),
            child: Text(
              'Previous Employees',
              style: TextStyle(
                fontSize: ThemeSize.titleFontSize,
                color: ThemeColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...previousEmployees.asMap().entries.map((entry) => Column(
                children: [
                  EmployeeCard(
                    key: ValueKey(entry.value.name),
                    employee: entry.value,
                    index: entry.key,
                    onDelete: (index) {
                      getIt<HomeBloc>().add(HomeEvent.deleteEmployee(index));
                    },
                  ),
                  Divider(
                    height: 1,
                    color: ThemeColors.borderGrey.withValues(alpha: 0.1),
                  ),
                ],
              )),
        ],
      ],
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final int index;
  final Function(int) onDelete;
  const EmployeeCard({
    super.key,
    required this.employee,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
        key: ObjectKey(index),
        trailingActions: <SwipeAction>[
          SwipeAction(
            icon: const CustomSvg(
              assetName: "assets/delete.svg",
            ),
            onTap: (CompletionHandler handler) async {
              onDelete(index);
            },
            color: Colors.red,
          ),
        ],
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeAddScreen(
                  employee: employee,
                  index: index,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: ThemeSize.fieldSpacingSmall,
              children: [
                Text(employee.name ?? '',
                    style: const TextStyle(
                      fontSize: ThemeSize.titleFontSize,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  employee.designation ?? '',
                  style: const TextStyle(
                    fontSize: ThemeSize.textFieldFontSize,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  employee.endDate != null
                      ? "${_formatDate(employee.startDate ?? DateTime.now())} - ${_formatDate(employee.endDate ?? DateTime.now())}"
                      : "From ${_formatDate(employee.startDate ?? DateTime.now())}",
                  style: const TextStyle(
                    fontSize: ThemeSize.textFieldFontSize,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
