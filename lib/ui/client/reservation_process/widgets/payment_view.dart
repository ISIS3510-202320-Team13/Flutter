import 'package:flutter/material.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Checkout',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        const Divider(),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_month),
                    horizontalSpace(60.0),
                    Text(
                      'Parking Details',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                verticalSpace(20.0),
                itemDefinition('Parking Name', 'City Parking - Uniandes'),
                verticalSpace(5.0),
                itemDefinition('Date', 'August 18th, 2023'),
                verticalSpace(5.0),
                itemDefinition('Time Range', '18:00 - 20:00')
              ],
            ),
          ),
        ),
        const Divider(),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_month),
                    horizontalSpace(60.0),
                    Text(
                      'Payment Details',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                verticalSpace(20.0),
                itemDefinition('Ticket Number', 'YR84K092KSJDY'),
                verticalSpace(5.0),
                itemDefinition('Cost', '13.000 COP'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
