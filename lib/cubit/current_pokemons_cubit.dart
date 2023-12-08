import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../model/pokemon.dart';
import 'package:http/http.dart' as http;

class CurrentPokemonsCubit extends Cubit<CurrentPokemonsState> {
  CurrentPokemonsCubit() : super(const CurrentPokemonsState());

  Future<void> fetchPokemons() async {
    if (state.query == "") {
      emit(state.copyWith(loading: true));
      final Response response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/?offset=${state.pokemons.length}\$limit=20"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        for (Map<String, dynamic> pokemon in body["results"]) {
          if (!state.pokemons.any((element) => element.name == pokemon["name"])) {
            emit(state.copyWith(pokemons: List.of(state.pokemons)..add(Pokemon.fromJson(pokemon))));
          }
        }
      }
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> getMoreData(Pokemon pokemon) async {
    if (pokemon.abilities.isEmpty || pokemon.forms.isEmpty) {
      Future.microtask(() async {
        final Response response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/${pokemon.name}"));
        if (response.statusCode == 200) {
          final Map<String, dynamic> body = jsonDecode(response.body);
          final int index = state.pokemons.indexOf(pokemon);
          if (index != -1) {
            Pokemon newPokemon = state.pokemons[index];
            for (var ability in body["abilities"]) {
              newPokemon = newPokemon.copyWith(abilities: [...newPokemon.abilities, Ability.fromMap(ability)]);
            }
            for (Map<String, dynamic> form in body["forms"]) {
              newPokemon = newPokemon.copyWith(forms: [...newPokemon.forms, Form.fromMap(form)]);
            }
            emit(state.copyWith(
                pokemons: List.of(state.pokemons)
                  ..removeAt(index)
                  ..insert(index, newPokemon)));
          }
        }
      });
    }
  }

  void changeQuery(String query) {
    emit(state.copyWith(query: query));
  }
}

class CurrentPokemonsState extends Equatable {
  final List<Pokemon> pokemons;
  final bool loading;
  final String query;
  const CurrentPokemonsState({
    this.pokemons = const [],
    this.loading = false,
    this.query = "",
  });

  @override
  List<Object?> get props => [pokemons, loading, query];

  CurrentPokemonsState copyWith({
    List<Pokemon>? pokemons,
    bool? loading,
    String? query,
  }) {
    return CurrentPokemonsState(
      query: query ?? this.query,
      pokemons: pokemons ?? this.pokemons,
      loading: loading ?? this.loading,
    );
  }
}
