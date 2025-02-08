import 'package:assignment/features/home/bloc/home_event.dart';
import 'package:assignment/features/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assignment/core/local_storage.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocalStorage storage = LocalStorage.instance;

  HomeBloc() : super(const HomeState.initial()) {
    on<HomeEvent>((event, emit) {
      return event.map(
        initial: (e) => _handleInitial(emit),
        getEmployee: (e) => _handleGetEmployee(emit),
        updateEmployee: (e) => _handleUpdateEmployee(e, emit),
        deleteEmployee: (e) => _handleDeleteEmployee(e, emit),
        add: (e) => _handleAddEmployee(e, emit),
      );
    });
  }

  void _handleInitial(Emitter<HomeState> emit) {
    final employees = storage.getEmployees();
    emit(HomeState.loaded(employees));
  }

  void _handleGetEmployee(Emitter<HomeState> emit) {
    emit(const HomeState.loading());
    final employees = storage.getEmployees();
    emit(HomeState.loaded(employees));
  }

  Future<void> _handleUpdateEmployee(
      UpdateEmployee event, Emitter<HomeState> emit) async {
    emit(const HomeState.loading());
    await storage.updateEmployee(event.employee, event.index);
    final employees = storage.getEmployees();
    emit(HomeState.updated(employees));
  }

  Future<void> _handleDeleteEmployee(
      DeleteEmployee event, Emitter<HomeState> emit) async {
    emit(const HomeState.loading());
    await storage.deleteEmployee(event.index);
    final employees = storage.getEmployees();
    emit(HomeState.loaded(employees));
  }

  Future<void> _handleAddEmployee(
      AddEmployee event, Emitter<HomeState> emit) async {
    try {
      emit(const HomeState.loading());
      await storage.addEmployee(event.employee);
      final employees = storage.getEmployees();
      emit(HomeState.loaded(employees));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }
}
