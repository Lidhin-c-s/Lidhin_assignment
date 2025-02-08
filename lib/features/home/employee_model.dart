import 'package:hive_flutter/hive_flutter.dart';
part 'employee_model.g.dart';

@HiveType(typeId: 1)
class Employee {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? designation;

  @HiveField(2)
  final DateTime? startDate;

  @HiveField(3)
  final DateTime? endDate;

  const Employee({
    required this.name,
    required this.designation,
    this.startDate,
    this.endDate,
  });

  factory Employee.fromHive(Map<dynamic, dynamic> hiveData) {
    return Employee(
      name: hiveData[0] as String?,
      designation: hiveData[1] as String?,
      startDate: hiveData[2] as DateTime?,
      endDate: hiveData[3] as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employee &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          designation == other.designation &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode =>
      name.hashCode ^
      designation.hashCode ^
      startDate.hashCode ^
      endDate.hashCode;
}
