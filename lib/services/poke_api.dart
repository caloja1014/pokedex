import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex/model/pokemon.dart';

class PokeApi {
  static PokeApi ?_instance;
  static const URL = 'https://pokeapi.co/api/v2/';
  static PokeApi get instance => _instance ??= PokeApi();
  final limit=20;
  var currentOffset = 0;

  Future<List<Pokemon>> getPokemons() async {
    var response = await http.get(Uri.parse(URL + 'pokemon?offset=$currentOffset&limit=$limit'));
    var json = jsonDecode(response.body);
    var pokemons = json['results'] as List;
    pokemons= pokemons.map((pokemon) => pokemon['name']).toList();
    currentOffset += limit;
    var listaPokemons = await Future.wait(pokemons.map((pokemon) => getPokemon(pokemon)));
    return listaPokemons;
  }

  Future<Pokemon> getPokemon(String name) async {
    var response = await http.get(Uri.parse(URL + 'pokemon/$name'));
    var json = jsonDecode(response.body);
    return Pokemon.fromJson(json);
  }
}
