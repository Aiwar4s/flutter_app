import 'package:flutter/material.dart';

class CitySearch extends SearchDelegate<String>{
  final List<String> cities;

  CitySearch(this.cities);

  bool _isValidCity(String city){
    return cities.contains(city);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(_isValidCity(query)){
      return ListTile(
        title: Text(query),
        onTap: (){close(context, query);},
      );
    } else {
      return const ListTile(
        title: Text('No results found'),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? cities
        : cities.where((city) => city.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestions[index]),
        onTap: (){close(context, suggestions[index]);},
      ),
    );
  }
}