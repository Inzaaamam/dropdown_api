import 'package:dropdown_api/City/city_model.dart';
import 'package:dropdown_api/Country/model.dart';
import 'package:dropdown_api/State/states_model.dart';
import 'package:equatable/equatable.dart';

abstract class CountState extends Equatable {
  @override
  List<Object> get props => [];
}
class CountInitial extends CountState {}
class CountLoading extends CountState {}
class CountLoaded extends CountState {
  final List<CountryModel> countries;
  CountLoaded(this.countries);
  @override
  List<Object> get props => [countries];
}
class StateLoaded extends CountState {
  final List<StateModel> states;
  StateLoaded(this.states);
  @override
  List<Object> get props => [states];
}
class CityLoaded extends CountState {
  final List<City> city;
  CityLoaded(this.city);
  @override
  List<Object> get props => [city];
}

class CountError extends CountState {
  final String message;
  CountError(this.message);

  @override
  List<Object> get props => [message];
}
