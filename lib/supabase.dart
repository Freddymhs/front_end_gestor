import 'package:flutter/material.dart';
import 'package:front_end_gestor/pages/home_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Initialize Supabase with your project URL and Anon Key
final supabase = Supabase.instance.client;

//  login with google for movil
Future<AuthResponse> googleSignInNative() async {
  print('googleSignInNative');
  const webClientId =
      '49813008970-1esk19a5uajf759fm3qvbaci7emnv7l9.apps.googleusercontent.com';

  const iosClientId =
      '49813008970-ebmf6qv6pd4m9m86f151ad4gmahi0a55.apps.googleusercontent.com';

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );

  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    throw 'Google Sign-In aborted.';
  }

  final googleAuth = await googleUser.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null || idToken == null) {
    throw 'Error retrieving tokens.';
  }

  return supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
}

// sign in with google web
Future<void> webGoogleSignIn() async {
  print('webGoogleSignIn');
  await supabase.auth.signInWithOAuth(OAuthProvider.google);
}

// get out of google
void signOutGoogle() async {
  print('signOutGoogle');
  try {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
    );
    await supabase.auth.signOut();
  } on AuthException catch (e) {
    throw (e.toString()); // fix :) future void signOutGoogle()
  }
}

//  always listen to auth state
void listenToAuthState(setState, userId, context, toWhere) {
  print('listenToAuthState');
  supabase.auth.onAuthStateChange.listen((data) {
    final user = data.session?.user;
    setState(() {
      userId = user?.id;
    });
    final existUserLogged = userId != null;
    if (toWhere == "toHome" && existUserLogged) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeView()),
        (Route<dynamic> route) => false,
      );
    }
  });
}
