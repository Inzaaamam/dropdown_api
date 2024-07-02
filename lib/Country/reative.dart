// ignore_for_file: avoid_print
// ignore: unused_import
import 'dart:developer';
import 'package:dropdown_api/City/city_model.dart';
import 'package:dropdown_api/Country/api.dart';
import 'package:dropdown_api/Country/cubit.dart';
import 'package:dropdown_api/Country/model.dart';
import 'package:dropdown_api/Country/state.dart';
import 'package:dropdown_api/State/states_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveDrop extends StatelessWidget {
  ReactiveDrop({super.key});
  final form = FormGroup({
    'country': FormControl<CountryModel>(validators: [Validators.required])
      ..valueChanges.listen((event) {
        // ignore:
        print('Changed to $event');
      }),
    'state': FormControl<StateModel>(validators: [Validators.required])
      ..valueChanges.listen((event) {
        // ignore:
        print('Changed to $event');
      }),
    'city': FormControl<City>(validators: [Validators.required])
      ..valueChanges.listen((event) {
        print('Changed to $event');
      })
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CountCubit(ApiClass())..fetchCountries(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Country, States and Cities'),
          ),
          body: BlocListener<CountCubit, CountState>(
            listener: (context, state) {
              // if (state is CountLoaded) {
              //   form.control('state').reset();
              //   // form.control('city').reset();
              // } else if (state is StateLoaded) {
              //   form.control('city').reset();
              // }
              if (state is CountError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fail to load data here')));
              }
            },
            child: BlocBuilder<CountCubit, CountState>(
              builder: (context, state) {
                List<CountryModel> countries =
                    context.read<CountCubit>().countries;
                List<StateModel> states = context.read<CountCubit>().states;
                List<City> cities = context.read<CountCubit>().city;
                // here is the code to get the data from the api and store it in the list we can runwithout thius code also
                // if (state is CountLoaded) {
                //   countries = state.countries;
                // } else if (state is StateLoaded) {
                //   states = state.states;
                // } else if (state is CityLoaded) {
                //   cities = state.city;
                // }
                // // ignore: prefer_interpolation_to_compose_strings
                // log('countries count: ' + countries.length.toString());
                // // ignore: prefer_interpolation_to_compose_strings
                // log('states count: ' + states.length.toString());
                // // ignore: prefer_interpolation_to_compose_strings
                // log('city count: ' + cities.length.toString());

                return ReactiveForm(
                  formGroup: form,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ReactiveDropdownField<CountryModel>(
                          formControlName: 'country',
                          hint: const Text('Select country...'),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          items: countries
                              .map((country) => DropdownMenuItem(
                                    value: country,
                                    child: Text(country.name ?? ''),
                                  ))
                              .toList(),
                          onChanged: (control) {
                            if (control.value != null) {
                              form.control('state').reset();
                              context.read<CountCubit>().fetchStates(control.value!.iso2!);
                              context.read<CountCubit>().fetchCity(
                                  form.control('country').value!.iso2!,
                                  control.value!.iso2!);
                            }
                            // ignore:
                            // print('Selected country: ${control.value?.name}');
                            // form.control('state').reset();
                            // context
                            //     .read<CountCubit>()
                            //     .fetchStates(control.value!.iso2!);
                            // context.read<CountCubit>().fetchCity(
                            //     form.control('country').value!.iso2!,
                            //     control.value!.iso2!);
                          },
                        ),
                        const SizedBox(height: 10),
                        ReactiveValueListenableBuilder<CountryModel>(
                          formControlName: 'country',
                          builder: (context, control, child) {
                            return Text(
                                'Selected country: ${control.value?.name}');
                          },
                        ),
                        const SizedBox(height: 10),
                        ReactiveDropdownField<dynamic>(
                          formControlName: 'state',
                          hint: const Text('Select state...'),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          items: states
                              .map((state) => DropdownMenuItem(
                                    value: state,
                                    child: Text(state.name ?? ''),
                                  ))
                              .toList(),
                          onChanged: (control) {
                            if (control.value != null && form.control('country').value != null) {
                              form.control('city').reset();
                              context.read<CountCubit>().fetchCity(
                                  form.control('country').value!.iso2!,
                                  control.value!.iso2!);
                            }
                            // ignore:
                            // print('Selected state: ${control.value.name}');
                            // form.control('city').reset();
                            // context.read<CountCubit>().fetchCity(
                            //     form.control('country').value.iso2!,
                            //     control.value.iso2!);
                          },
                        ),
                        const SizedBox(height: 10),
                        ReactiveValueListenableBuilder<StateModel>(
                          formControlName: 'state',
                          builder: (context, control, child) {
                            return Text(
                                'Selected state: ${control.value?.name}');
                          },
                        ),
                        const SizedBox(height: 10),
                        ReactiveDropdownField<City>(
                          formControlName: 'city',
                          hint: const Text('Select city...'),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          items: cities
                              .map((city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city.name ?? ''),
                                  ))
                              .toList(),
                          onChanged: (control) {},
                        ),
                        const SizedBox(height: 10),
                        ReactiveValueListenableBuilder<City>(
                          formControlName: 'city',
                          builder: (context, control, child) {
                            return Text(
                                'Selected city: ${control.value?.name}');
                          },
                        ),
                        const SizedBox(height: 20),
                        ReactiveFormConsumer(builder: (context, form, child) {
                          return GestureDetector(
                              onTap: () {
                                if (form.valid) {
                                  final country =
                                      form.control('country').value ??
                                          'Country';
                                  final state =
                                      form.control('state').value ?? 'State';
                                  final city =
                                      form.control('city').value ?? 'City';
                                  context.read<CountCubit>().storedata(
                                      country.name!, state.name!, city.name!);
                                  print(city);
                                  print(state);
                                  print(country);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Data  Insert successfully')));

                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please fill all fields')));
                                }
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green),
                                child: const Center(child: Text('Insert Data',style: TextStyle(color: Colors.white, fontSize: 20),)),
                              ));
                        })
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
