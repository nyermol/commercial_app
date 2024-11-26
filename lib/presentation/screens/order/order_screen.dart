import 'package:commercial_app/domain/usecases/validation_usecase.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/widgets/text_button.dart';
import 'package:commercial_app/presentation/screens/order/components/order_body.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final String userName;
  const OrderScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(S.of(context).order),
        actions: <Widget>[
          TextButtonWidget(validationUsecase: sl<ValidationUsecase>()),
        ],
      ),
      body: OrderScreenBody(userName: userName),
    );
  }
}
