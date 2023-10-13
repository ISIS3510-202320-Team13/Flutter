import 'package:flutter/material.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build method called');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Payment',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        verticalSpace(20.0),
        itemDefinition('Price', '13.000 COP'),
        verticalSpace(5.0),
        itemDefinition('Parking Name', 'City Parking - Uniandes'),
        verticalSpace(5.0),
        itemDefinition('Date', 'August 18th, 2023'),
        verticalSpace(5.0),
        itemDefinition('Time Range', '18:00 - 20:00'),
        const Divider(),
        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.credit_card),
            hintText: 'Enter your credit card number',
            labelText: 'Credit Card Number *',
          ),
          // validator: (String? value) {},
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today),
            hintText: 'MM/YY',
            labelText: 'Expiration Date *',
          ),
          keyboardType: TextInputType.datetime,
        ),
        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.lock),
            hintText: 'Enter your card secret code',
            labelText: 'Card Secret Code *',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
