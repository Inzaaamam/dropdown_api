import 'package:bloc/bloc.dart';
import 'package:dropdown_api/City/city_model.dart';
import 'package:dropdown_api/Country/api.dart';
import 'package:dropdown_api/Country/state.dart';
import 'package:dropdown_api/Country/model.dart';
import 'package:dropdown_api/State/states_model.dart';

class CountCubit extends Cubit<CountState> {
  final ApiClass api;
  List<CountryModel> countries = [];
  List<StateModel> states = [];
  List<City> city =[];

  CountCubit(this.api) : super(CountInitial());

  void fetchCountries() async {
    emit(CountLoading());
    try {
      countries = await api.countryData();
      emit(CountLoaded(countries));
    } catch (e) {
      emit(CountError("Failed to load countries"));
    }
  }

  void fetchStates(String iso2) async {
    emit(CountLoading());
    try {
     states = await api.stateData(iso2);
      emit(StateLoaded(states));
    } catch (e) {
      emit(CountError("Failed to load states"));
    }
  }
   void fetchCity(String iso2 , String province) async {
    emit(CountLoading());
    try {
     city = await api.cityData(iso2, province);
      emit(CityLoaded(city));
    } catch (e) {
      emit(CountError("Failed to load states"));
    }
  }
}

// import 'package:bloc/bloc.dart';
// import 'package:dropdown_api/Country/api.dart';
// import 'package:dropdown_api/Country/state.dart';
// class CountCubit extends Cubit<CountState> {
//   final ApiClass api;
//   CountCubit(this.api) : super(CountInitial());
//   void fetchCountries() async {
//     emit(CountLoading());
//     try {
//       final countries = await api.countryData();
//       emit(CountLoaded(countries));
//     } catch (e) {
//       emit(CountError("Failed to load countries"));
//     }
//   }
//   void fetchStates(String iso2) async {
//     emit(CountLoading());
//     try {
//       final states = await api.stateData(iso2);
//       emit(StateLoaded(states));
//     } catch (e) {
//       emit(CountError("Failed to load states"));
//     }
//   }
// }
