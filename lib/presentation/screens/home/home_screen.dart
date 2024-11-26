import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/home/components/home_screen_bar.dart';
import 'package:commercial_app/presentation/screens/home/components/home_screen_body.dart';
import 'package:commercial_app/presentation/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> validationState =
        context.watch<ValidationCubit>().state;
    if (mounted && validationState['show_snackbar'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showCustomSnackBar(
            context,
            S.of(context).requiredAllField,
            Colors.red,
          );
          context.read<ValidationCubit>().resetSnackBar();
        }
      });
    }
    return Scaffold(
      body: HomeScreenBody(
        pageController: _pageController,
        onPageChanged: (int index) => setState(
          () => _selectedIndex = index,
        ),
        userName: widget.userName,
      ),
      bottomNavigationBar: HomeScreenBar(
        selectedIndex: _selectedIndex,
        onTabChange: (int index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeInOut,
          );
        },
        validationState: validationState,
      ),
    );
  }
}
