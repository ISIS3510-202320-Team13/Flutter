import 'package:flutter/material.dart';

import 'payment_view.dart';

class ProcessStepper extends StatefulWidget {
  const ProcessStepper({super.key});

  @override
  State<ProcessStepper> createState() => _ProcessStepperState();
}

class _ProcessStepperState extends State<ProcessStepper> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _index,
      connectorThickness: 2.0,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 2) {
          setState(() {
            _index += 1;
          });
        }
      },
      steps: <Step>[
        Step(
          isActive: _index == 0,
          // label: const Text('Parking Details'),
          title: const Text(''),
          content: Center(child: const Text('Parking Details')),
        ),
        Step(
          isActive: _index == 1,
          // label: const Text('Reservation Details'),
          title: const Text(''),
          content: Center(child: const Text('Reservation Details')),
        ),
        Step(
          isActive: _index == 2,
          // label: const Text('Payment'),
          title: const Text(''),
          content: Center(child: const Text('Payment')),
        ),
        Step(
          isActive: _index == 3,
          // label: const Text('Checkout'),
          title: const Text(''),
          // content: Center(child: const Text('Checkout')),
          content: Container(child: PaymentView()),
        ),
      ],
    );
  }
}
