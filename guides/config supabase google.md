# Guía completa para obtener la huella digital SHA-1 y crear el ID de cliente de OAuth de Google para tu aplicación flutter 

1https://www.youtube.com/watch?v=utMg6fVmX0U

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

# Google Sign-In de Supabae en Flutter(android/web)

1. proyecto de flutter creado
2. instalar google-sign-in (pub.dev/packages/google_sign_in) y supabase_flutter (pub.dev/packages/supabase_flutter)
   1. flutter pub add google_sign_in 
   2. flutter pub add supabase_flutter
3. go to https://console.cloud.google.com/apis/credentials
   1. create credentials for chrome
   2. create credentials for android
      * get the package name from "build.gradle" from your project
      * get SHA-1 with "keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android" in terminal
   3. create credentials for ios

      * get the package id 
        * open ios/runner.xcworkspace
          * runner -> general -> Identity -> Bundle Identifier
4. go to supabase
   1. create a project
      * authentication -> providers -> google 
        * enable it
        * enable skip none checks for ios
        * copy the client web id and paste it in the "Authorized Client IDs (for Android, One Tap, and Chrome extensions)" field and Client ID (for OAuth) from supabase
        * copy the client anon from web and past it in Client Secret (for OAuth) from supabase
        * doit: add http://localhost:3000/ into URL CONFGURATION into supabase
        * doit: go to supabase -> providers-> Callback URL (for OAuth) and copy it to paste into google console web client id 'URI de redireccionamiento autorizados'
   2. go to https://pub.dev/packages/google_sign_in_ios#ios-integration
      1. complete the step 6 and replace com.googleusercontent.apps.[your-ios-client-id]
      2. copy the example and paste under the last TRUE from info.plist
      3. paste and edit the "<string>com.googleusercontent.apps.49813008970-ebmf6qv6pd4m9m86f151ad4gmahi0a55</string>"
         * remember remove the ".apps.googleusercontent.com"

5. into main.dart 
   1. add:   await Supabase.initialize(url: 'https://...', anonKey: 'somestring');
      1. all this data is from   supabase.com-> ProjectSettings -> API -> URL && ANON
6. test supabase client works in main.dart
   1. test this code
```
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

final supabase = Supabase.instance.client;

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
  // runApp(MyApp(settingsController: settingsController));
  // test supabase client with google sign in
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user?.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                await googleSignIn();
              } else {
                webGoogleSignIn();
              }
            },
            child: Text('Hola-> ${_userId}')),
      ),
    );
  }
}

Future<void> webGoogleSignIn() async {
  supabase.auth.signInWithOAuth(OAuthProvider.google);
}

Future<AuthResponse> googleSignIn() async {
  /// TODO: update the Web client ID with your own.
  ///
  /// Web Client ID that you registered with Google Cloud.
  const webClientId =
      '49813008970-1esk19a5uajf759fm3qvbaci7emnv7l9.apps.googleusercontent.com';

  /// TODO: update the iOS client ID with your own.
  ///
  /// iOS Client ID that you registered with Google Cloud.
  const iosClientId =
      '49813008970-ebmf6qv6pd4m9m86f151ad4gmahi0a55.apps.googleusercontent.com';

  // Google sign in on Android will work without providing the Android
  // Client ID registered on Google Cloud.

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null) {
    throw 'No Access Token found.';
  }
  if (idToken == null) {
    throw 'No ID Token found.';
  }

  return supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
}

```


# generate web build

flutter build web

# configurando coneccion en la web supabase + google cloud console

ingresar a google cloud console

- copiar id cliente de web y pegarlo dentro del provider supabase
- copiar secreto del cliente web y pegarlo dentro del provider supabase

ingresar al provider supabase

- copiar callback url que me da provider supabase y pegarlo en "URI de redireccionamiento autorizados" de google cloud
  - https://samvrmunxovxptwwmplv.supabase.co/auth/v1/callback

# final config

- recuerda ir a config URL CONFIGURATION
  - https://supabase.com/dashboard/project/samvrmunxovxptwwmplv/auth/url-configuration
  - puede cambiar para prod y para dev como usar localhost o una url vercel
