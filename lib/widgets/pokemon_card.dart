import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard(
    this.pokemon, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.push("/info", extra: pokemon);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1)],
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  pokemon.name.length > 1 ? pokemon.name[0].toUpperCase() + pokemon.name.substring(1) : pokemon.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
