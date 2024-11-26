import 'package:commercial_app/domain/usecases/validation_usecase.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/widgets/text_button.dart';
import 'package:commercial_app/presentation/screens/measurements/components/measurements_body.dart';
import 'package:flutter/material.dart';

class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(S.of(context).measurements),
        actions: <Widget>[
          TextButtonWidget(
            validationUsecase: sl<ValidationUsecase>(),
          ),
        ],
      ),
      body: const MeasurementsScreenBody(),
    );
  }
}
