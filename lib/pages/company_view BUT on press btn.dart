import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/pages/Layout/main_layout.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String YOUR_QUERY = """
query(\$companyId: ID!){
  getMyCompanyUsers(companyId: \$companyId) {
    name
    id
    email
  }
}
""";

class CompanyView extends StatefulWidget {
  static const routeName = companyRoute;
  const CompanyView({super.key});

  @override
  State<CompanyView> createState() => _CompanyViewState();
}

class _CompanyViewState extends State<CompanyView> {
  @override
  Widget build(BuildContext context) {
    return const BaseLayout(child: Center(child: TabBarViewExample()));
  }
}

//
//
//
class TabBarViewExample extends StatefulWidget {
  const TabBarViewExample({super.key});

  @override
  State<TabBarViewExample> createState() => _TabBarViewExampleState();
}

class _TabBarViewExampleState extends State<TabBarViewExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = GraphQLProvider.of(context)
        ?.value; // Obtener el cliente GraphQL del contexto
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: managementUsers),
            // Tab(text: 'Tab 2'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                  color: Colors.red,
                  child: Column(
                    children: [
                      Text(users.toString()),
                      // Text(users.toString()),
                      const Center(
                        child: Text('Contenido de la pestaña 1'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Al presionar el botón, se realiza la consulta utilizando el cliente GraphQL obtenido del contexto
                          fetchData(client!);
                        },
                        child: Text('Obtener Usuarios'),
                      ),
                    ],
                  )),
              // Text("este es mi tab 2"),
            ],
          ),
        ),
      ],
    );
  }

  void fetchData(GraphQLClient client) async {
    setState(() {
      isLoading =
          true; // Establece isLoading en true para mostrar el indicador de carga
    });
    try {
      final result = await client.query(
          QueryOptions(document: gql(YOUR_QUERY), variables: {'companyId': 1}));
      if (result.hasException) {
        // Handle potential errors
        print(result.exception);
        return; // or handle error gracefully
      }
      // Assuming no errors, access user data
      final data = result.data;

      // results
      if (data != null && data['getMyCompanyUsers'] != null) {
        final List<dynamic> userList = data['getMyCompanyUsers'];

        setState(() {
          users = userList;
        });
        // Proceed with user data processing (steps from previous response)
      } else {
        // Handle case where no users are found
        print('No user data found in the query result.');
      }
      // result.data?['userExists'] != null;
      setState(() {
        users = result.data?['getMyCompanyUsers'] ?? [];
      });
    } catch (e) {
      // Manejar errores aquí
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading =
            false; // Establece isLoading en false después de completar la consulta
      });
    }
  }
}
