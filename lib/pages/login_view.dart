import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/pages/home_view.dart';
import 'package:front_end_gestor/supabase.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';

var log = Logger();
String USER_EXISTS = """
query (\$userId: ID!) {
  userExists(userId: \$userId) {
    id
    supabaseId
    email
    name
    Company {
      id
      name
      userId
    }
    profile {
      id
      bio
      role
      userId
    }

  }
}
    """;
Future<void> _validateUserInDatabase(context, _id) async {
  try {
    final result = await GraphQLProvider.of(context).value.query(
          QueryOptions(document: gql(USER_EXISTS), variables: {'userId': _id}),
        );
    final userExists = result.data?['userExists'] != null;
    final useHasCompany = result.data?['userExists']['Company'] != null;
    if (userExists && useHasCompany) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeView()),
        (Route<dynamic> route) => false,
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"Error:$e"')),
    );
  }
}

class LoginView extends StatefulWidget {
  static const routeName = loginRoute;
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? _id;
  // aun nose enq e usar todo esto :) quizas deberia darse a un context
  String? _email;
  String? _email_verified;
  String? _last_sign_in_at;
  String? _access_token;
  String? _fullName;
  String? _newEmail;
  String? _provider;
  String? _superMessage;

  Future<void> _signInWithGoogle() async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await googleSignInNative();
      } else {
        await webGoogleSignIn();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ingresando a la app: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _id = data.session?.user?.id;
        _email = data.session?.user?.userMetadata?['email'];
        _email_verified =
            data.session?.user.userMetadata?['email_verified'].toString();
        _last_sign_in_at = data.session?.user?.lastSignInAt.toString();
        _access_token = data.session?.accessToken;
        _fullName = data.session?.user.userMetadata?['full_name'].toString();
        _newEmail = data.session?.user?.userMetadata?['new_email'].toString();
        _provider = data.session?.user?.appMetadata?['provider'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userLoggedIn = _id != null;
    if (userLoggedIn) _validateUserInDatabase(context, _id);

    return Scaffold(
        appBar: AppBar(
          title: const Text(loginPageTitle),
        ),
        body: Center(
          child: ElevatedButton.icon(
            icon: Image.asset(
              'assets/images/google.png',
              width: 28,
            ),
            onPressed: _signInWithGoogle,
            label: const Text(signInWithGoogle),
          ),
        ));
  }
}
