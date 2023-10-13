import 'package:equatable/equatable.dart';

enum PaymentMethods { creditCard, debitCard }

class Payment extends Equatable {
  // TODO: Add new fields (e.g., location)

  final String id;
  final double? price;
  final PaymentMethods? paymentMethod;

  const Payment({required this.id, this.price, this.paymentMethod});

  static const empty = Payment(id: '');

  bool get isEmpty => this == Payment.empty;
  bool get isNotEmpty => this != Payment.empty;

  @override
  List<Object?> get props => [id, price, paymentMethod];
}
