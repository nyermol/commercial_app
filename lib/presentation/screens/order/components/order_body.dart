import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/order/components/order_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreenBody extends StatefulWidget {
  final String userName;
  const OrderScreenBody({super.key, required this.userName});

  @override
  State<OrderScreenBody> createState() => _OrderScreenBodyState();
}

class _OrderScreenBodyState extends State<OrderScreenBody> {
  late String orderNumber = '';
  late String inspectionDate = '';
  late String specialistName = '';
  late String customerName = '';

  @override
  void initState() {
    super.initState();
    orderNumber = context.read<DataCubit>().state['order_number'] ?? '';
    inspectionDate = context.read<DataCubit>().state['inspection_date'] ?? '';
    specialistName = widget.userName;
    customerName = context.read<DataCubit>().state['customer_name'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: getHorizontalPadding(context, 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  OrderTextField(
                    labelText: S.of(context).orderNumber,
                    hintText: S.of(context).orderNumberEnter,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(numberRegExp),
                    ],
                    onTextChanged: (String value) {
                      setState(() {
                        orderNumber = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    dataKey: 'order_number',
                  ),
                  OrderTextField(
                    labelText: S.of(context).inspectionDate,
                    hintText: S.of(context).inspectionDateEnter,
                    onTextChanged: (String value) {
                      setState(() {
                        inspectionDate = value;
                      });
                    },
                    dataKey: 'inspection_date',
                    isDateField: true,
                  ),
                  OrderTextField(
                    labelText: S.of(context).specialistName,
                    hintText: S.of(context).specialistNameEnter,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(textRegExp),
                    ],
                    onTextChanged: (String value) {
                      setState(() {
                        specialistName = value;
                      });
                    },
                    dataKey: 'specialist_name',
                    initialText: specialistName,
                  ),
                  OrderTextField(
                    labelText: S.of(context).customerName,
                    hintText: S.of(context).customerNameEnter,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(textRegExp),
                    ],
                    onTextChanged: (String value) {
                      setState(() {
                        customerName = value;
                      });
                    },
                    dataKey: 'customer_name',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
