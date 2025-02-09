import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
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
  late String city = '';
  late String orderNumber = '';
  late String inspectionDate = '';
  late String specialistName = '';
  late String customerName = '';
  late String residence = '';
  // Установка FocusNode для переключения между полями
  final FocusNode _orderNumberFocus = FocusNode();
  final FocusNode _specialistNameFocus = FocusNode();
  final FocusNode _customerNameFocus = FocusNode();
  final FocusNode _residenceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    city = context.read<DataCubit>().state['city'] ?? '';
    orderNumber = context.read<DataCubit>().state['order_number'] ?? '';
    inspectionDate = context.read<DataCubit>().state['inspection_date'] ?? '';
    // Получение значения из Firebase Firestore при авторизации в виджете SignInScreen
    specialistName = widget.userName;
    customerName = context.read<DataCubit>().state['customer_name'] ?? '';
    residence = context.read<DataCubit>().state['residence'] ?? '';
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
          child: SingleChildScrollView(
            child: Padding(
              padding: getHorizontalPadding(context, 0.05),
              child: Column(
                children: <Widget>[
                  OrderTextField(
                    labelText: S.of(context).city,
                    hintText: S.of(context).chooseCity,
                    onTextChanged: (String value) {
                      setState(() {
                        city = value;
                      });
                    },
                    dataKey: 'city',
                    isCityField: true,
                  ),
                  OrderTextField(
                    labelText: S.of(context).orderNumber,
                    hintText: S.of(context).orderNumberEnter,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onTextChanged: (String value) {
                      setState(() {
                        orderNumber = value;
                      });
                    },
                    focusNode: _orderNumberFocus,
                    nextFocusNode: _specialistNameFocus,
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
                      FilteringTextInputFormatter.allow(
                        nameRegExp,
                      ),
                    ],
                    onTextChanged: (String value) {
                      setState(() {
                        specialistName = value;
                      });
                    },
                    dataKey: 'specialist_name',
                    initialText: specialistName,
                    focusNode: _specialistNameFocus,
                    nextFocusNode: _customerNameFocus,
                  ),
                  OrderTextField(
                    labelText: S.of(context).customerName,
                    hintText: S.of(context).customerNameEnter,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        nameRegExp,
                      ),
                    ],
                    onTextChanged: (String value) {
                      setState(() {
                        customerName = value;
                      });
                    },
                    dataKey: 'customer_name',
                    focusNode: _customerNameFocus,
                    nextFocusNode: _residenceFocus,
                    textInputAction: TextInputAction.done,
                  ),
                  OrderTextField(
                    labelText: S.of(context).nameOfResidence,
                    hintText: S.of(context).residence,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        textRegExp,
                      ),
                    ],
                    onTextChanged: (String value) {
                      setState(() {
                        residence = value;
                      });
                    },
                    dataKey: 'residence',
                    focusNode: _residenceFocus,
                    textInputAction: TextInputAction.done,
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
