import 'package:flutter/material.dart';
import 'package:front_end_gestor/src/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'src/app.dart';
import 'components/atoms/settings/settings_controller.dart';
import 'components/atoms/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // supabase start
  await Supabase.initialize(
      url: 'https://samvrmunxovxptwwmplv.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhbXZybXVueG92eHB0d3dtcGx2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY0MDIzMzUsImV4cCI6MjAzMTk3ODMzNX0.PJIVMNERI_gkwivQgKyOESsV1broFywi6vSLT1slFrM');

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
