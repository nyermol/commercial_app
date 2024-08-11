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
      color: const Color.fromRGBO(236, 129, 49, 1),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          primaryPadding,
          primaryPadding,
          primaryPadding,
          MediaQuery.of(context).viewPadding.bottom,
        ),
        child: GNav(
          backgroundColor: const Color.fromRGBO(236, 129, 49, 1),
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: const Color.fromRGBO(246, 192, 153, 1),
          gap: basePadding,
          padding: const EdgeInsets.all(allPadding),
          textStyle:
              const TextStyle(color: Colors.white, fontSize: textFontSize),
          tabs: <GButton>[
            GButton(
              icon: Icons.numbers,
              text: S.of(context).order,
              leading: validationState['order_number_valid'] &&
                      validationState['inspection_date_valid'] &&
                      validationState['specialist_name_valid'] &&
                      validationState['customer_name_valid']
                  ? null
                  : const Icon(Icons.error, color: Colors.red),
            ),
            GButton(
              icon: Icons.list,
              text: S.of(context).remarks,
              leading: validationState['electricsItems_valid'] &&
                      validationState['geometryItems_valid'] &&
                      validationState['plumbingEquipmentItems_valid'] &&
                      validationState['windowsAndDoorsItems_valid'] &&
                      validationState['finishingItems_valid']
                  ? null
                  : const Icon(Icons.error, color: Colors.red),
            ),
            GButton(
              icon: Icons.device_thermostat,
              text: S.of(context).measurements,
            ),
            GButton(icon: Icons.rule, text: S.of(context).options),
          ],
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
        ),
      ),
    );
  }
}
