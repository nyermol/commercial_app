import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreenBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final Map<String, dynamic> validationState;

  const HomeScreenBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.validationState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF24555E),
      child: Padding(
        padding: const EdgeInsets.all(primaryPadding),
        child: GNav(
          backgroundColor: const Color(0xFF24555E),
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: const Color(0xFF3C676F),
          gap: basePadding,
          padding: const EdgeInsets.all(allPadding),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: textFontSize,
          ),
          tabs: <GButton>[
            GButton(
              icon: Icons.numbers,
              text: S.of(context).order,
              // Смена иконки при валидации пустого поля
              leading: validationState['city_valid'] &&
                      validationState['order_number_valid'] &&
                      validationState['inspection_date_valid'] &&
                      validationState['specialist_name_valid'] &&
                      validationState['customer_name_valid'] &&
                      validationState['residence_valid']
                  ? null
                  : const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
            ),
            GButton(
              icon: Icons.list,
              text: S.of(context).remarks,
            ),
            GButton(
              icon: Icons.device_thermostat,
              text: S.of(context).measurements,
            ),
            GButton(
              icon: Icons.rule,
              text: S.of(context).options,
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
        ),
      ),
    );
  }
}
