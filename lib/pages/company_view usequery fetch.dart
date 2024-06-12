import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/pages/Layout/main_layout.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Importa flutter_hooks

const String userQuery = """
query(\$companyId: ID!){
  getMyCompanyUsers(companyId: \$companyId) {
    name
    id
    email
  }
}
""";

class CompanyView extends HookWidget {
  // Cambia StatelessWidget por HookWidget
  static const routeName = companyRoute;

  @override
  Widget build(BuildContext context) {
    final QueryOptions options = QueryOptions(
      document: gql(userQuery),
      variables: {
        'companyId': 1
      }, // Asegúrate de pasar el ID de usuario correcto aquí
      pollInterval: const Duration(seconds: 10),
    );

    final result =
        useQuery(options); // Usa useQuery directamente en el método build
    final aver = result.result;

    if (aver.data == null) {
      return const Text('Loading');
    }

    if (aver.hasException) {
      return Text(aver.exception.toString());
    }

    final List<dynamic> listData = aver.data?['getMyCompanyUsers'];

    return BaseLayout(
      child: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) {
          final item = listData[index];
          return ListTile(
            title: Text(item['name'] ?? 'Unknown'),
            subtitle: Text('ID: ${item['id']}'),
          );
        },
      ),
    );
  }
}
