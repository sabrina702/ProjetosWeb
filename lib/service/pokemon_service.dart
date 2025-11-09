import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:myapp/data/models/pokemon.dart';

class PokemonService {
  static const String apiUrl = 'https://www.canalti.com.br/api/pokemons.json';

  Future<Pokemon> fetchRandomPokemon() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final pokemons = (data['pokemon'] as List)
          .map((p) => Pokemon.fromJson(p))
          .toList();

      final random = Random();
      return pokemons[random.nextInt(pokemons.length)];
    } else {
      throw Exception('Erro ao carregar os Pokémons');
    }
  }
}
