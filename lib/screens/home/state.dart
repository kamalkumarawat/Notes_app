import 'home_screen.dart';
import 'model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}
class HomeError extends HomeState {
  final String? error;
  HomeError(this.error);
}

class HomeLoaded extends HomeState {
  final dynamic? notes;

  HomeLoaded({required this.notes});
}
