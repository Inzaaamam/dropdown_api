import 'package:dio/dio.dart';
import 'package:dropdown_api/City/city_model.dart';
import 'package:dropdown_api/Country/model.dart';
import 'package:dropdown_api/State/states_model.dart';

class ApiClass {
  final Dio _dio = Dio();
  Future<List<CountryModel>> countryData() async {
    try {
      final response = await _dio.get(
          'https://api.countrystatecity.in/v1/countries',
          options: Options(headers: {
            "X-CSCAPI-KEY":
                "NFlmbVBYVWhvcXFRc3lkblAwSTE5OTlpV0dxenNIeTkzdWdZSTF4Wg=="
          }));
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => CountryModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load ListingModel');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<List<StateModel>> stateData(String iso2) async {
    try {
      final urlstate = 'https://api.countrystatecity.in/v1/countries/$iso2/states';
      // ignore: avoid_print
      print('Requesting URL: $urlstate');
      final res = await _dio.get(
        urlstate,
        options: Options(headers: {
          "X-CSCAPI-KEY":
              "NFlmbVBYVWhvcXFRc3lkblAwSTE5OTlpV0dxenNIeTkzdWdZSTF4Wg=="
        }),
      );
      if (res.statusCode == 200) {
        return (res.data as List)
            .map((json) => StateModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load StateModel');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
  
  Future<List<City>> cityData(String iso2, String province) async {
    try {
      final url = 'https://api.countrystatecity.in/v1/countries/$iso2/states/$province/cities';
      // ignore: avoid_print
      // print('Requesting URL: $url');
      final city = await _dio.get(
        url,
        options: Options(headers: {
          "X-CSCAPI-KEY":
              "NFlmbVBYVWhvcXFRc3lkblAwSTE5OTlpV0dxenNIeTkzdWdZSTF4Wg=="
        }),
      );
      if (city.statusCode == 200) {
        return (city.data as List)
            .map((json) => City.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load StateModel');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
