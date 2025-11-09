import 'package:flutter/material.dart';
import 'package:myapp/data/models/pokemon.dart';
import 'package:myapp/presentation/pages/home/homePage.dart';
import 'package:myapp/presentation/pages/perfil/perfilDrawer.dart';
import 'package:myapp/presentation/widgets/custom_bottom_nav.dart';
import 'package:myapp/service/pokemon_service.dart';
import 'package:myapp/theme/text_styles.dart';

class PokemonPage extends StatefulWidget {
  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final PokemonService _pokemonService = PokemonService();
  Pokemon? _pokemon;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  Future<void> _loadPokemon() async {
    try {
      final pokemon = await _pokemonService.fetchRandomPokemon();
      setState(() {
        _pokemon = pokemon;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PerfilDrawer(),
      appBar: AppBar(title: const Text('🎉 Seu prêmio Pokémon!')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _pokemon == null
            ? const Text('Erro ao carregar Pokémon.')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(_pokemon!.image, height: 150),
                  const SizedBox(height: 20),
                  Text(
                    _pokemon!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tipo: ${_pokemon!.type.join(', ')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.home),
                    label: const Text(
                      'Voltar para o Início',
                      style: AppTextStyles.button,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}
