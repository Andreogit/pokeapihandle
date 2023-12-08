// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  final String name;
  final String url;
  final List<Ability> abilities;
  final List<Form> forms;
  const Pokemon({
    required this.name,
    required this.url,
    required this.abilities,
    required this.forms,
  });
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
      abilities: const [],
      forms: const [],
    );
  }

  @override
  List<Object?> get props => [name, url, abilities, forms];

  Pokemon copyWith({
    String? name,
    String? url,
    List<Ability>? abilities,
    List<Form>? forms,
  }) {
    return Pokemon(
      name: name ?? this.name,
      url: url ?? this.url,
      abilities: abilities ?? this.abilities,
      forms: forms ?? this.forms,
    );
  }
}

class Ability extends Equatable {
  final Map<String, dynamic> ability;
  final int slot;
  final bool isHidden;
  const Ability({
    required this.ability,
    required this.slot,
    required this.isHidden,
  });

  @override
  List<Object> get props => [ability, slot, isHidden];

  Ability copyWith({
    Map<String, dynamic>? ability,
    int? slot,
    bool? isHidden,
  }) {
    return Ability(
      ability: ability ?? this.ability,
      slot: slot ?? this.slot,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  factory Ability.fromMap(Map<String, dynamic> map) {
    return Ability(
      ability: Map<String, dynamic>.from((map['ability'] as Map<String, dynamic>)),
      slot: map['slot'] as int,
      isHidden: map['is_hidden'] as bool,
    );
  }

  factory Ability.fromJson(String source) => Ability.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}

class Form extends Equatable {
  final String name;
  final String url;
  const Form({
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [name, url];

  factory Form.fromMap(Map<String, dynamic> map) {
    return Form(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  factory Form.fromJson(String source) => Form.fromMap(json.decode(source) as Map<String, dynamic>);
}
