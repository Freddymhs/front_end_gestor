import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/main.dart';
import 'package:front_end_gestor/pages/home_view.dart';
import 'package:front_end_gestor/supabase.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  static const routeName = loginRoute;
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final log = Logger();
  late UserData userData; // Declarar userData como una variable de instancia

  String? _id; //supabaseIOd
  late UserData _fullName; // Declarar userData como una variable de instancia
  late UserData _supabaseId;
  late UserData _companyName;

  @override
  void initState() {
    super.initState();
    userData = Provider.of<UserData>(context, listen: false);
    supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      setState(() {
        _id = user?.id;
      });

      if (_id != null) _validateUserInDatabase(context, _id);
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await googleSignInNative();
      } else {
        await webGoogleSignIn();
      }
    } catch (e) {
      _showSnackBar('Error ingresando a la app: $e');
    }
  }

  Future<void> _validateUserInDatabase(BuildContext context, supabaseId) async {
    const query = '''
      query (\$userId: ID!) {
        userExists(userId: \$userId) {
          id
          supabaseId
          email
          name
          role
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
    ''';

    try {
      final result = await GraphQLProvider.of(context).value.query(
            QueryOptions(
                document: gql(query), variables: {'userId': supabaseId}),
          );

      final userExists = result.data?['userExists'] != null;
      final userHasCompany = result.data?['userExists']['Company'] != null;
      final thisSupabaseIdExistInDb =
          _id != result.data?['userExists']['supabaseId'];

      if (thisSupabaseIdExistInDb) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginView()),
          (Route<dynamic> route) => false,
        );
      }
      if (userExists && userHasCompany) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeView()),
          (Route<dynamic> route) => false,
        );

        userData.setUserData(
            role: result.data?['userExists']['role'],
            companyName: result.data?['userExists']['Company']['name'],
            companyId: result.data?['userExists']['Company']['id'].toString(),
            fullName: result.data?['userExists']['name']);
      }
    } catch (e) {
      log.e('Error validando usuario: $e');
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(loginPageTitle)),
      body: Center(
        child: GoogleSignInButton(onPressed: _signInWithGoogle),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({required this.onPressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.asset('assets/images/google.png', width: 28),
      onPressed: onPressed,
      label: const Text(signInWithGoogle),
    );
  }
}
