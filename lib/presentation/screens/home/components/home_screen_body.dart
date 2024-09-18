import 'package:commercial_app/presentation/screens/order/order_screen.dart';
import 'package:commercial_app/presentation/screens/remarks/remarks_screen.dart';
import 'package:commercial_app/presentation/screens/measurements/measurements_screen.dart';
import 'package:commercial_app/presentation/screens/options/optoins_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenBody extends StatelessWidget {
  final String userName;
  final PageController pageController;
  final Function(int) onPageChanged;

  const HomeScreenBody({
    super.key,
    required this.userName,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: <Widget>[
        OrderScreen(userName: userName),
        const RemarksScreen(),
        const MeasurementsScreen(),
        const OptionsScreen(),
      ],
    );
  }
}
