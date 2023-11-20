import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {required this.id,
      this.email,
      this.name,
      this.picture,
      this.reservations});

  final String? name;
  final String? email;
  final String id;
  final String? picture;
  final Map<String, dynamic>? reservations;

  // Unauthenticated user
  static const empty = User(
      id: '',
      email: '',
      name: '',
      picture:
          'https://st3.depositphotos.com/9998432/13335/v/1600/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg',
      reservations: {'': ''});

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, picture, reservations];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'picture': picture,
      'reservations': jsonEncode(reservations),
    };
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'picture': picture,
      'reservations': reservations,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      picture: json['picture'],
      reservations: jsonDecode(json['reservations']),
    );
  }
}
