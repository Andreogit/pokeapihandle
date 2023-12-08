import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/current_pokemons_cubit.dart';
import '../widgets/pokemon_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = ScrollController();
  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<CurrentPokemonsCubit>().fetchPokemons();
      }
    });
    context.read<CurrentPokemonsCubit>().fetchPokemons();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        title: const Text(
          "Pokemon API",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            padding: const EdgeInsets.all(10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(0, 1))],
              borderRadius: BorderRadius.circular(99),
            ),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade400),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextField(
                      onChanged: (str) {
                        context.read<CurrentPokemonsCubit>().changeQuery(str);
                      },
                      cursorColor: Colors.grey.shade400,
                      decoration: const InputDecoration.collapsed(hintText: "Search pokemon", hintStyle: TextStyle(color: Colors.grey)),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              color: Colors.black,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await context.read<CurrentPokemonsCubit>().fetchPokemons();
              },
              child: BlocBuilder<CurrentPokemonsCubit, CurrentPokemonsState>(builder: (context, state) {
                return ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: state.pokemons.where((element) => element.name.contains(state.query)).length + 1,
                    itemBuilder: (context, index) {
                      return state.query == ""
                          ? index == state.pokemons.length
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : PokemonCard(state.pokemons[index])
                          : PokemonCard(state.pokemons[index]);
                    });
              }),
            ),
          ),
        ],
      ),
    );
  }
}
