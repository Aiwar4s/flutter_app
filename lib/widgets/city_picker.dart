import 'package:flutter/material.dart';
import 'package:flutter_app/providers/city_provider.dart';
import 'package:provider/provider.dart';

import '../services/city_search.dart';

class CityPicker extends StatefulWidget{
  final Function(String) onCitySelected;
  final Function(bool) onValidated;

  const CityPicker({super.key, required this.onCitySelected, required this.onValidated});

  @override
  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker>{
  String selectedCity = '';
  String? errorText;

  String? _validateCity(String? value, List<String> cities){
    if(value == null || value.isEmpty || !cities.contains(value)){
      return 'Please select a city';
    }
    return null;
  }

  @override
  Widget build(BuildContext context){
    List<String> cities = Provider.of<CityProvider>(context).cities;

    return Form(
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              foregroundColor: Colors.black, backgroundColor: Colors.white,
              shadowColor: Colors.grey,
            ),
            onPressed: () async{
              final city = await showSearch(context: context, delegate: CitySearch(cities));
              if(city != null){
                setState(() {
                  selectedCity = city;
                  widget.onCitySelected(city);
                  errorText = _validateCity(city, cities);
                  widget.onValidated(errorText == null);
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        selectedCity.isEmpty ? 'Select City' : selectedCity,
                        style: TextStyle(color: selectedCity.isEmpty ? Colors.grey : Colors.black)
                    )
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          errorText != null ? Text(errorText!, style: const TextStyle(color: Colors.red)) : const SizedBox.shrink(),
        ]
      ),
    );
  }
}