import 'package:assignment/features/home/employee_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._();
  LocalStorage._();

  static LocalStorage get instance => _instance;

  Future<void> initHive() async {
    await Hive.initFlutter();
  }

  Future<void> registerAdapters() async {
    Hive.registerAdapter(EmployeeAdapter());
  }

  Future<void> openBox() async {
    try {
      await Hive.openBox<Employee>('employees');
    } catch (e) {
      print("Error opening box: $e");
    }
  }

  Future<void> closeBox() async {
    await Hive.close();
  }

  Future<void> addEmployee(Employee employee) async {
    await Hive.box<Employee>('employees').put(employee.name, employee);
  }

  List<Employee> getEmployees() {
    try {
      return Hive.box<Employee>('employees').values.toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteEmployee(int index) async {
    final box = Hive.box<Employee>('employees');
    await box.deleteAt(index);
  }

  Future<void> updateEmployee(Employee employee, int index) async {
    final box = Hive.box<Employee>('employees');
    await box.putAt(index, employee);
  }
}
