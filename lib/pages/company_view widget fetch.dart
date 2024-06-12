import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/pages/Layout/main_layout.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String userQuery = """
query(\$companyId: ID!){
  getMyCompanyUsers(companyId: \$companyId) {
    name
    id
    email
  }
}
""";

class CompanyView extends StatelessWidget {
  static const routeName = companyRoute;
  // const CompanyView({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        child: Query(
      options: QueryOptions(
        document: gql(userQuery),
        variables: {'companyId': 1}, // Ensure you pass the correct user ID here
        pollInterval: const Duration(seconds: 10),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        // print();

        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Text('Loading');
        }

        var listData = result?.data?['getMyCompanyUsers'];

        if (listData == null) {
          return const Text('No user data');
        }

        return ListView.builder(
          itemCount: listData!.length,
          itemBuilder: (context, index) {
            final item = listData[index];
            return ListTile(
              title: Text(item['name'] ?? 'Unknown'),
              subtitle: Text('ID: ${item['id']}'),
            );
          },
        );
        // return Text(user['name'] ?? 'No name');
      },
    ));
  }
}
