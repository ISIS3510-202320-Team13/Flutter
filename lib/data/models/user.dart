import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({this.reservations, required this.id, this.email, this.name, this.photo});

  final String? name;
  final String? email;
  final String id;
  final String? photo;
  final List<String>? reservations;

  // Unauthenticated user
  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, photo];

  factory User.fromSnapshot(Map<String, dynamic> snapshot) {
    return User(
      id: snapshot['id'] as String,
      email: snapshot['email'] as String?,
      name: snapshot['name'] as String?,
      photo: snapshot['photo'] as String?,
      reservations: snapshot['reservations'] as List<String>?,
    );
  }
}
