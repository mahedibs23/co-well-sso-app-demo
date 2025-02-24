import 'package:flutter/material.dart';
import 'package:hello_flutter/presentation/base/base_ui_state.dart';
import 'package:hello_flutter/presentation/feature/settings/screen/widgets/language_settings.dart';
import 'package:hello_flutter/presentation/feature/settings/screen/widgets/theme_settings.dart';
import 'package:hello_flutter/presentation/feature/settings/settings_view_model.dart';

class SettingsMobilePortrait extends StatefulWidget {
  final SettingsViewModel viewModel;

  const SettingsMobilePortrait({required this.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => SettingsMobilePortraitState();
}

class SettingsMobilePortraitState extends BaseUiState<SettingsMobilePortrait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ThemeSettings(viewModel: widget.viewModel),
            LanguageSettings(viewModel: widget.viewModel),
          ],
        ),
      ),
    );
  }
}
