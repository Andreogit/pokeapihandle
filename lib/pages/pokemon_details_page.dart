import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/current_pokemons_cubit.dart';
import '../model/pokemon.dart';

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailsPage(this.pokemon, {Key? key}) : super(key: key);

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  @override
  void initState() {
    context.read<CurrentPokemonsCubit>().getMoreData(widget.pokemon);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CurrentPokemonsCubit, CurrentPokemonsState>(
        builder: (context, state) {
          final Pokemon pokemon = state.pokemons.firstWhere((e) => e.url == widget.pokemon.url);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.pokemon.name.length > 1
                          ? widget.pokemon.name[0].toUpperCase() + widget.pokemon.name.substring(1)
                          : widget.pokemon.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.7,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "Abilities",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...pokemon.abilities.map(
                    (e) => AbilityCard(e.ability["name"], e.ability["url"]),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class AbilityCard extends StatelessWidget {
  final String name;
  final String url;
  const AbilityCard(this.name, this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.width / 4 - 25,
          width: size.width / 4 - 25,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(
                Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), (Random().nextDouble() * 10).round().toDouble()),
          ),
        ),
        Text(
          name[0].toUpperCase() + name.substring(1),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
