import 'package:flutter/material.dart';
import 'package:front_end_gestor/components/atoms/settings/settings_controller.dart';
import 'package:front_end_gestor/components/atoms/settings/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:front_end_gestor/src/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserData()),
      ],
      child: MyApp(settingsController: settingsController),
    ),
  );
}

class UserData extends ChangeNotifier {
  String? _fullName; //
  String? _id;
  String? _email;
  String? _emailVerified;
  String? _lastSignInAt;
  String? _accessToken;
  String? _newEmail;
  String? _provider;
  String? _superMessage;
  String? _role; //
  String? _companyName; //
  String? _companyId; //

  String? get fullName => _fullName;
  String? get id => _id;
  String? get email => _email;
  String? get emailVerified => _emailVerified;
  String? get lastSignInAt => _lastSignInAt;
  String? get accessToken => _accessToken;
  String? get newEmail => _newEmail;
  String? get provider => _provider;
  String? get superMessage => _superMessage;
  String? get role => _role;
  String? get companyName => _companyName;
  String? get companyId => _companyId;

  // void setFullName(String? name) {
  //   _fullName = name;
  //   notifyListeners();
  // }

  void setUserData({
    String? id,
    String? email,
    String? emailVerified,
    String? lastSignInAt,
    String? accessToken,
    String? fullName,
    String? newEmail,
    String? provider,
    String? superMessage,
    String? role,
    String? companyName,
    String? companyId,
  }) {
    _id = id;
    _email = email;
    _emailVerified = emailVerified;
    _lastSignInAt = lastSignInAt;
    _accessToken = accessToken;
    _fullName = fullName;
    _newEmail = newEmail;
    _provider = provider;
    _superMessage = superMessage;
    _role = role;
    _companyName = companyName;
    _companyId = companyId;

    notifyListeners(); // Notificar a los listeners que los datos han cambiado
  }
}
