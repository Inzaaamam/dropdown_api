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
        print('Changed to $event');
      }),
    'state': FormControl<StateModel>(validators: [Validators.required])
      ..valueChanges.listen((event) {
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Country, States and Cities'),
        ),
        body: BlocListener<CountCubit, CountState>(
          listener: (context, state) {
            if (state is StateLoaded) {
              // form.control('state').reset();
              // form.control('city').reset();
            } else if (state is CityLoaded) {
              // form.control('city').reset();
            } else if (state is CountLoaded) {
              form.control('state').reset();
              form.control('city').reset();
            }
          },
          child: BlocBuilder<CountCubit, CountState>(
            builder: (context, state) {
              List<CountryModel> countries =
                  context.read<CountCubit>().countries;
              List<StateModel> states = context.read<CountCubit>().states;
              List<City> cities = context.read<CountCubit>().city;

              if (state is CountLoaded) {
                countries = state.countries;
              } else if (state is StateLoaded) {
                states = state.states;
              } else if (state is CityLoaded) {
                cities = state.city;
              }

              log('countries count: ' + countries.length.toString());
              log('states count: ' + states.length.toString());
              log('city count: ' + cities.length.toString());

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
                          print('Selected country: ${control.value?.name}');
                          form.control('state').reset();
                          form.control('city').reset();
                          context
                              .read<CountCubit>()
                              .fetchStates(control.value!.iso2!);
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
                      ReactiveDropdownField<StateModel>(
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
                          print('Selected state: ${control.value?.name}');
                          form.control('city').reset();
                          context.read<CountCubit>().fetchCity(
                              form.control('country').value!.iso2!,
                              control.value!.iso2!);
                        },
                      ),
                      const SizedBox(height: 10),
                      ReactiveValueListenableBuilder<StateModel>(
                        formControlName: 'state',
                        builder: (context, control, child) {
                          return Text('Selected state: ${control.value?.name}');
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
                      ),
                      const SizedBox(height: 10),
                      ReactiveValueListenableBuilder<City>(
                        formControlName: 'city',
                        builder: (context, control, child) {
                          return Text('Selected city: ${control.value?.name}');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


// import 'package:dropdown_api/City/city_model.dart';
// import 'package:dropdown_api/Country/api.dart';
// import 'package:dropdown_api/Country/cubit.dart';
// import 'package:dropdown_api/Country/model.dart';
// import 'package:dropdown_api/Country/state.dart';
// import 'package:dropdown_api/State/states_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:reactive_forms/reactive_forms.dart';

// class ReactiveDrop extends StatelessWidget {
//   ReactiveDrop({super.key});
//   final form = FormGroup({
//     'country': FormControl<CountryModel>(validators: [Validators.required])
//       ..valueChanges.listen((event) {
//         // ignore: avoid_print
//         print('Changed to $event');
//       }),
//     'state': FormControl<StateModel>(validators: [Validators.required])
//       ..valueChanges.listen((event) {
//         // ignore: avoid_print
//         print('Changed to $event');
//       }),
//     'city': FormControl<City>(validators: [Validators.required])
//       ..valueChanges.listen((event) {
//         // ignore: avoid_print
//         print('Changed to $event');
//       })
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CountCubit(ApiClass())..fetchCountries(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Country, States and Cities'),
//         ),
//         body: BlocListener<CountCubit, CountState>(
//           listener: (context, state) {
//             if (state is StateLoaded) {
//               // Reset the state dropdown when new states are loaded
//               form.control('state').reset();
//             } else if (state is CityLoaded) {
//               // Reset the city dropdown when new cities are loaded
//               form.control('city').reset();
//             }
//           },
//           child: BlocBuilder<CountCubit, CountState>(
//             builder: (context, state) {
//               List<CountryModel> countries = context.read<CountCubit>().countries;
//               List<StateModel> states = context.read<CountCubit>().states;
//               List<City> cities = context.read<CountCubit>().city;

//               if (state is CountLoaded) {
//                 countries = state.countries;
//               } else if (state is StateLoaded) {
//                 states = state.states;
//               } else if (state is CityLoaded) {
//                 cities = state.city;
//               }

//               return ReactiveForm(
//                 formGroup: form,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ReactiveDropdownField<CountryModel>(
//                         formControlName: 'country',
//                         hint: const Text('Select country...'),
//                         decoration: InputDecoration(
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                         ),
//                         items: countries
//                             .map((country) => DropdownMenuItem(
//                                   value: country,
//                                   child: Text(country.name ?? ''),
//                                 ))
//                             .toList(),
//                         onChanged: (control) {
//                           // ignore: avoid_print
//                           print('Selected country: ${control.value?.name}');
//                           context.read<CountCubit>().fetchStates(control.value!.iso2!);
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       ReactiveValueListenableBuilder<CountryModel>(
//                         formControlName: 'country',
//                         builder: (context, control, child) {
//                           return Text('Selected country: ${control.value?.name}');
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       ReactiveDropdownField<StateModel>(
//                         formControlName: 'state',
//                         hint: const Text('Select state...'),
//                         decoration: InputDecoration(
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                         ),
//                         items: states
//                             .map((state) => DropdownMenuItem(
//                                   value: state,
//                                   child: Text(state.name ?? ''),
//                                 ))
//                             .toList(),
//                         onChanged: (control) {
//                           context.read<CountCubit>().fetchCity(control.value!.iso2!);
//                           // ignore: avoid_print
//                           print('Selected state: ${control.value?.name}');
//                         },
//                         // enabled: states.isNotEmpty,
//                       ),
//                       const SizedBox(height: 10),
                      
//                       ReactiveValueListenableBuilder<StateModel>(
//                         formControlName: 'state',
//                         builder: (context, control, child) {
//                           return Text('Selected state: ${control.value?.name}');
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       ReactiveDropdownField<City>(
//                         formControlName: 'city',
//                         hint: const Text('Select city...'),
//                         decoration: InputDecoration(
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                         ),
//                         items: cities
//                             .map((city) => DropdownMenuItem(
//                                   value: city,
//                                   child: Text(city.name ?? ''),
//                                 ))
//                             .toList(),
//                       //  enableFeedback : cities.isNotEmpty,
//                       ),
//                       const SizedBox(height: 10),
//                       ReactiveValueListenableBuilder<City>(
//                         formControlName: 'city',
//                         builder: (context, control, child) {
//                           return Text('Selected city: ${control.value?.name}');
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// Ensure your CountCubit, ApiClass, and models (CountryModel, StateModel, City) are correctly defined and imported.

// import 'package:dropdown_api/City/city_model.dart';
// import 'package:dropdown_api/Country/state.dart';
// import 'package:dropdown_api/State/states_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:dropdown_api/Country/cubit.dart';
// import 'package:dropdown_api/Country/api.dart';
// import 'package:dropdown_api/Country/model.dart';
// class ReactiveDrop extends StatelessWidget {
//   ReactiveDrop({super.key});
//   final form = FormGroup({
//     'country': FormControl<CountryModel>(validators: [Validators.required])
//       ..valueChanges.listen((event) {
//         // ignore: avoid_print
//         print('Changed to $event');
//       }),
//     'state': FormControl<StateModel>(validators: [Validators.required])
//       ..valueChanges.listen((event) {
//         // ignore: avoid_print
//         print('Changed to $event');
//       }),
//     'city': FormControl<City>(validators: [Validators.required])
//       ..valueChanges.listen((event) {
//         // ignore: avoid_print
//         print('Changed to $event');
//       })
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CountCubit(ApiClass())..fetchCountries(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Country , States and Cities'),
//         ),
//         body: BlocListener<CountCubit, CountState>(
//           listener: (context, state) {
//             if (state is StateLoaded) {
//               // Reset the state dropdown when new states are loaded
//               form.control('state').reset();
//               // form.control('city').reset();
//             }
//           },
//           child: BlocBuilder<CountCubit, CountState>(
//             builder: (context, state) {
//               List<CountryModel> countries =
//                   context.read<CountCubit>().countries;
//               List<StateModel> states = [];
//               if (state is CountLoaded) {
//                 countries = state.countries;
//               } else if (state is StateLoaded) {
//                 states = state.states;
//               }
//               return ReactiveForm(
//                 formGroup: form,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ReactiveDropdownField<CountryModel>(
//                         formControlName: 'country',
//                         hint: const Text('Select country...'),
//                         decoration: InputDecoration(
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                         ),
//                         items: countries
//                             .map((country) => DropdownMenuItem(
//                                   value: country,
//                                   child: Text(country.name ?? ''),
//                                 ))
//                             .toList(),
//                         onChanged: (control) {
//                           // ignore: avoid_print
//                           print('Selected country: ${control.value?.name}');
//                           context
//                               .read<CountCubit>()
//                               .fetchStates(control.value!.iso2!);
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       ReactiveValueListenableBuilder<CountryModel>(
//                         formControlName: 'country',
//                         builder: (context, control, child) {
//                           return Text(
//                               'Selected country: ${control.value?.name}');
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       if (state is StateLoaded || state is CountLoaded)
//                         ReactiveDropdownField<StateModel>(
//                           formControlName: 'state',
//                           hint: const Text('Select state...'),
//                           decoration: InputDecoration(
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5)),
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5)),
//                           ),
//                           items: states
//                               .map((state) => DropdownMenuItem(
//                                     value: state,
//                                     child: Text(state.name ?? ''),
//                                   ))
//                               .toList(),
//                           onChanged: (control) {
//                             // ignore: avoid_print
//                             print('Selected state: ${control.value?.name}');
//                           },
//                         ),
//                       const SizedBox(height: 10),
//                       if (state is StateLoaded)
//                         ReactiveValueListenableBuilder<StateModel>(
//                           formControlName: 'state',
//                           builder: (context, control, child) {
//                             return Text(
//                                 'Selected state: ${control.value?.name}');
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'package:dropdown_api/Country/state.dart';
// import 'package:dropdown_api/State/states_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:dropdown_api/Country/cubit.dart';
// import 'package:dropdown_api/Country/api.dart';
// import 'package:dropdown_api/Country/model.dart';
// class ReactiveDrop extends StatelessWidget {
//   ReactiveDrop({super.key});
//   final form = FormGroup({
//     'country': FormControl<CountryModel>(
//       validators: [Validators.required],
//     )..valueChanges.listen((event) {
//         // ignore: avoid_print
//         print('Changed to $event');
//       }),
//        'iso2': FormControl<StateModel>(
//       validators: [Validators.required],
//     )..valueChanges.listen((event) {
//         // ignore: avoid_print
//         print('Changed to $event');
//       })
//   });
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CountCubit(ApiClass())..fetchCountries(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Reactive dropdown'),
//         ),
//         body: BlocBuilder<CountCubit, CountState>(
//           builder: (context, state) {
//             if (state is CountLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is CountLoaded) {
//               return ReactiveForm(
//                 formGroup: form,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ReactiveDropdownField<CountryModel>(
//                         formControlName: 'country',
//                         hint: const Text('Select country...'),
//                         decoration: InputDecoration(
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                         ),
//                         items: state.countries
//                             .map((country) => DropdownMenuItem(
//                                   value: country,
//                                   child: Text(country.name ?? ''),
//                                 ))
//                             .toList(),
//                         onChanged: (control) {
//                           // ignore: avoid_print
//                           print('Selected country: ${control.value?.name}');
//                           ApiClass().stateData(control.value!.iso2!);
                          
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       ReactiveValueListenableBuilder<CountryModel>(
//                         formControlName: 'country',
//                         builder: (context, control, child) {
//                           return Text(
//                               'Selected country: ${control.value?.name}');
//                         },
//                       ),
//                      const  SizedBox(height: 10,),
//                        ReactiveDropdownField<StateModel>(
//                         formControlName: 'iso2',
//                         hint: const Text('Select state...'),
//                         decoration: InputDecoration(
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                         ),
                      
//                         items: state.states
//                             .map((iso2) => DropdownMenuItem(
//                                   value: iso2,
//                                   child: Text(iso2.iso2),
//                                 ))
//                             .toList(),
//                         onChanged: (control) {
//                           // ignore: avoid_print
//                           print('Selected State: ${control.value?.iso2}');
//                         },
//                       ),
                    
//                     ],
//                   ),
//                 ),
//               );
//             } else if (state is CountError) {
//               return Center(child: Text(state.message));
//             }
//             return Container();
//           },
//         ),
//       ),
//     );
//   }
// }
