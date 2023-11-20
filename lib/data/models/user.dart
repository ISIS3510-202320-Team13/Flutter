import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.picture,
    this.reservations,
    this.type,
  });

  final String? name;
  final String? email;
  final String id;
  final String? picture;
  final Map<String, dynamic>? reservations;
  final int? type;

  // Unauthenticated user
  static const empty = User(id: '', email: '', name: '', picture: '', reservations: {'': ''}, type: 0);

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, picture, reservations, type];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'picture': picture,
      'reservations': reservations != null ? jsonEncode(reservations) : null,
      'type': type,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      picture: json['picture'],
      reservations: json['reservations'] != null ? jsonDecode(json['reservations']) : null,
      type: json['type'],
    );
  }
}
