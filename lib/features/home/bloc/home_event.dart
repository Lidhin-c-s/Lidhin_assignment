import 'package:assignment/features/home/employee_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'home_event.freezed.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.initial() = Initial;
  const factory HomeEvent.getEmployee() = GetEmployee;
  const factory HomeEvent.updateEmployee(Employee employee, int index) =
      UpdateEmployee;
  const factory HomeEvent.deleteEmployee(int index) = DeleteEmployee;
  const factory HomeEvent.add(Employee employee) = AddEmployee;
}
