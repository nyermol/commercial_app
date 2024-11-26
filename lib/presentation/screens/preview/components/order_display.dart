import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDisplay extends StatefulWidget {
  const OrderDisplay({super.key});

  @override
  State<OrderDisplay> createState() => _OrderDisplayState();
}

class _OrderDisplayState extends State<OrderDisplay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, Map<String, dynamic>>(
      builder: (BuildContext context, Map<String, dynamic> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                S.of(context).orderMainInf,
                style: titleStyle,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  S.of(context).orderNumber,
                  style: mainLabelStyle,
                ),
                const Text(':'),
                Text(
                  ' ${state['order_number'] ?? S.of(context).notSpecified}',
                  style: secondaryLabelStyle,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  S.of(context).inspectionDate,
                  style: mainLabelStyle,
                ),
                const Text(':'),
                Text(
                  ' ${state['inspection_date'] ?? S.of(context).notSpecified}',
                  style: secondaryLabelStyle,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  S.of(context).specialistName,
                  style: mainLabelStyle,
                ),
                const Text(':'),
                Text(
                  ' ${state['specialist_name'] ?? S.of(context).notSpecified}',
                  style: secondaryLabelStyle,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  S.of(context).customerName,
                  style: mainLabelStyle,
                ),
                const Text(':'),
                Text(
                  ' ${state['customer_name'] ?? S.of(context).notSpecified}',
                  style: secondaryLabelStyle,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
