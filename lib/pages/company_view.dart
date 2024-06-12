import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/Util/gqls.dart';
import 'package:front_end_gestor/pages/Layout/main_layout.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CompanyView extends HookWidget {
  static const routeName = companyRoute;

  @override
  Widget build(BuildContext context) {
    final companyUsersData = useQuery(QueryOptions(
      document: gql(getMyCompanyUsersQuery),
      variables: {'companyId': 1},
    ));

    final permissionsData = useQuery(QueryOptions(
      document: gql(getAllPermissionsQuery),
    ));

    final addStarMutation = useMutation(MutationOptions(
      document: gql(updatePermissionMutation),
      onCompleted: (dynamic resultData) {
        companyUsersData.refetch();
      },
    ));

    final listData = companyUsersData.result.data?['getMyCompanyUsers'];
    final listDataAllPermissions =
        permissionsData.result.data?['getAllPermissions'];

    return BaseLayout(
      child: UserTable(
        listData: List<Map<String, dynamic>>.from(listData ?? []),
        allPermissions:
            List<Map<String, dynamic>>.from(listDataAllPermissions ?? []),
        runMutation: addStarMutation.runMutation,
      ),
    );
  }
}

class UserTable extends StatefulWidget {
  final List<Map<String, dynamic>> listData;
  final List<Map<String, dynamic>> allPermissions;
  final RunMutation runMutation;

  const UserTable({
    Key? key,
    required this.listData,
    required this.allPermissions,
    required this.runMutation,
  }) : super(key: key);

  @override
  _UserTableState createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  final Map<String, dynamic> userDataUpdated = {};

  @override
  Widget build(BuildContext context) {
    final listDataFormatted = widget.listData.map((user) {
      final userPermissions = user['permission']?.toList() ?? [];
      final updatedPermissions = widget.allPermissions.map((perm) {
        final existingPerm = userPermissions.firstWhere(
          (up) => up['id'] == perm['id'],
          orElse: () => null,
        );
        return {
          ...perm,
          'enabled': existingPerm != null,
        };
      }).toList();

      return {
        ...user,
        'permission': updatedPermissions,
      };
    }).toList();

    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const UserTableHeader(),
            Divider(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listDataFormatted.length,
              itemBuilder: (context, index) {
                final item = listDataFormatted[index];
                return UserDataRow(
                  userData: item,
                  userDataUpdated: userDataUpdated,
                  onEdit: () => _showEditModal(context, item),
                  onDelete: () => _confirmDelete(context, item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, Map<String, dynamic> userData) {
    setState(() {
      userDataUpdated.clear();
      userDataUpdated.addAll(userData);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditUserModal(
          userData: userData,
          userDataUpdated: userDataUpdated,
          onSaveChanges: () {
            widget.runMutation({
              'id': userData['id'],
              'role': userDataUpdated['role'],
              'permissions': userDataUpdated['permission']
                  .where((permission) => permission['enabled'] == true)
                  .map((permission) => permission['id'].toString())
                  .toList()
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, user) {
    final userName = user['name'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Desactivar Usuario'),
          content: Text(
              '¿Estás seguro de que quieres ${user['enabled'] ? 'desactivar' : 'activar'} el acceso de $userName?'),
          actions: [
            TextButton(
              onPressed: () => {Navigator.of(context).pop()},
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => {
                print('Desactivar usuario: $userName'),
                print('user ${user['id']}'),
                //
                widget.runMutation({
                  'id': user['id'],
                  'enabled': !user['enabled'],
                }),
                Navigator.of(context).pop()
                //
              },
              child: Text('Desactivar'),
            ),
          ],
        );
      },
    );
  }
}

class EditUserModal extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> userDataUpdated;
  final VoidCallback onSaveChanges;

  const EditUserModal({
    Key? key,
    required this.userData,
    required this.userDataUpdated,
    required this.onSaveChanges,
  }) : super(key: key);

  @override
  _EditUserModalState createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Usuario'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow('Nombre', widget.userData['name']),
            buildRow('Email', widget.userData['email']),
            buildRoleDropdown(),
            buildRow('Activo', widget.userData['enabled'].toString()),
            buildOptionsRow('Permisos', widget.userData['permission']),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: widget.onSaveChanges,
          child: Text('Guardar'),
        ),
      ],
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              'Rol:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: widget.userDataUpdated['role'] ?? widget.userData['role'],
              onChanged: (String? newValue) {
                setState(() {
                  widget.userDataUpdated['role'] = newValue!;
                });
              },
              items: <String>['WORKER', 'ADMIN', 'CLIENT']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsRow(String label, List<dynamic> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (values == null || values.isEmpty)
            Text('Sin opciones')
          else
            ...values.map((value) {
              return Row(
                children: [
                  Expanded(
                    child: Text(value['name'] ?? ''),
                  ),
                  Switch(
                    value: value['enabled'] ?? false,
                    onChanged: (bool newValue) {
                      setState(() {
                        value['enabled'] = newValue;
                      });
                    },
                  ),
                ],
              );
            }).toList(),
        ],
      ),
    );
  }
}

class UserDataRow extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> userDataUpdated;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserDataRow({
    required this.userData,
    required this.userDataUpdated,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(userData['name']),
          ),
          Expanded(
            flex: 2,
            child: Text(userData['email']),
          ),
          Expanded(
            flex: 1,
            child: Text(userData['role']),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: userData['enabled'] == true
                      ? Icon(Icons.person,
                          color: Colors.black) // Active user: Black icon
                      : Icon(Icons.person_outline,
                          color: Colors.grey[400]), // Disabled user: Gray icon
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserTableHeader extends StatelessWidget {
  const UserTableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Nombre',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Rol',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
