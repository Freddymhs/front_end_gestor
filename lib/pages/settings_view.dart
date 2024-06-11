import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/pages/Layout/main_layout.dart';

import '../components/atoms/settings/settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = settingsRoute;

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        child: Padding(
      padding: const EdgeInsets.all(16),
      // Glue the SettingsController to the theme selection DropdownButton.
      //
      // When a user selects a theme from the dropdown list, the
      // SettingsController is updated, which rebuilds the MaterialApp.
      child: DropdownButton<ThemeMode>(
        // Read the selected themeMode from the controller
        value: controller.themeMode,
        // Call the updateThemeMode method any time the user selects a theme.
        onChanged: controller.updateThemeMode,
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text(systemTheme),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text(systemLight),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text(systemDark),
          )
        ],
      ),
    ));
  }
}
