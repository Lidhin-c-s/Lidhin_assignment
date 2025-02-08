import 'package:assignment/features/home/employee_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = Initial;
  const factory HomeState.loading() = Loading;
  const factory HomeState.loaded(List<Employee> employees) = Loaded;
  const factory HomeState.updated(List<Employee> employees) = Updated;
  const factory HomeState.error(String message) = Error;
}
