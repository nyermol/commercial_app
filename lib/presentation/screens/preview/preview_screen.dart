import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/screens/preview/components/preview_export.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).preview),
      ),
      body: const PreviewScreenBody(),
    );
  }
}
